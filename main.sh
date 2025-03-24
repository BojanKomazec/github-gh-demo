check_if_installed() {
    app_name=$1
    if ! command -v $app_name &> /dev/null; then
        echo "❌ $app_name is not installed. Please install $app_name to proceed."
        exit 1
    fi

    echo "✅ $app_name is installed."
}

get_current_branch() {
    BRANCH=$(git branch --show-current)

    # Check if branch is found
    if [[ -z "$BRANCH" ]]; then
        echo "❌ Failed to determine current branch."
        return 1
    fi

    echo "🚀 Current script is running on branch: $BRANCH"
}

fetch_worfklows() {
    # Fetch list of workflows
    echo "🔍 Fetching available workflows..."
    WORKFLOWS=$(gh workflow list --json name --jq '.[].name')
    WORKFLOWS=($WORKFLOWS)

    # Check if workflows are found
    if [[ -z "$WORKFLOWS" ]]; then
        echo "❌ No workflows found."
        return 1
    fi

    echo "✅ Workflows found:"
    # Iterate over workflows
    for workflow in "${WORKFLOWS[@]}"; do
        echo "  - $workflow"
    done
}

fetch_worfklows_in_repo() {
    REPO=$1

    # Fetch list of workflows
    echo "🔍 Fetching available workflows in repository: $REPO..."
    response=$(gh workflow list --repo $REPO --json name)
    if [[ $? -ne 0 ]]; then
        echo "❌ Failed to fetch workflows in repository: $REPO."
        return 1
    fi

    echo $response | jq .

    WORKFLOWS=$(gh workflow list --repo $REPO --json name --jq '.[].name')

    # Convert this to array
    WORKFLOWS=($WORKFLOWS)

    # Check if workflows are found
    if [[ -z "$WORKFLOWS" ]]; then
        echo "❌ No workflows found in repository: $REPO."
        return 1
    fi

    echo "✅ Workflows found in repository: $REPO"
    # Iterate over workflows
    for workflow in "${WORKFLOWS[@]}"; do
        echo "  - $workflow"
    done
}

main() {
    check_if_installed "git"
    check_if_installed "gh"
    check_if_installed "jq"

    get_current_branch
    fetch_worfklows
    fetch_worfklows_in_repo "bojankomazec/github-gh-demo"
    fetch_worfklows_in_repo "hashicorp/terraform"
}

main "$@"