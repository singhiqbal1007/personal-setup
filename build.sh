source .env
docker build -t personal-setup:latest --build-arg USER_NAME="$USER_NAME" --build-arg USER_EMAIL="$USER_EMAIL" . --load
