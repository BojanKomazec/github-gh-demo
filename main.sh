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
        exit 1
    fi

    echo "🚀 Current script is running on branch: $BRANCH"
}

main() {
    check_if_installed "git"
    check_if_installed "gh"

    get_current_branch
}

main "$@"