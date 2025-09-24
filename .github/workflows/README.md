# GitHub Actions Workflows

## PHP Docker Images Build Workflow

This repository includes a GitHub Actions workflow (`build-php-images.yml`) that automatically builds and pushes multi-platform PHP Docker images to Docker Hub.

### Features

- **Multi-platform builds**: Supports both AMD64 (Intel) and ARM64 (Apple Silicon) architectures
- **Distributed builds**: Uses matrix strategy to build images across multiple runners in parallel
- **Multiple PHP versions**: Currently builds modern versions of PHP
- **Automatic cleanup**: Removes build artifacts after completion
- **Triggers**: Currently manual, may be automated later

### Setup Requirements

Before using this workflow, you need to configure the following secrets in your GitHub repository:

1. Go to your repository settings → Secrets and variables → Actions
2. Add the following *Repository Secrets*:
   - `DOCKER_USERNAME`: Your personal Docker Hub username (organisations can't have logins/tokens)
   - `DOCKER_PASSWORD`: Your personal Docker Hub access token

### Workflow Triggers

Currently this GitHub action can only be triggered manually. In the future we may automate it.

When you run the GitHub action you can optionally specify a custom tag to use. This will default to `latest`.

### Workflow Process

1. **Build Job**:
   - Creates a matrix of 8 build combinations (4 PHP versions × 2 platforms)
   - Each combination builds and pushes a platform-specific image by digest
   - Uploads build digests as temporary artifacts

2. **Merge Job**:
   - Downloads digests from all platform builds for each PHP version
   - Creates multi-platform manifest lists using `docker buildx imagetools create`
   - Pushes final multi-platform images with tags like `wearepvtl/php-fpm-8.4:latest`

3. **Cleanup Job**:
   - Automatically removes temporary digest artifacts

### Generated Images

The workflow creates 3-5 modern PHP src images. eg. `wearepvtl/php-fpm-8.4:latest`

Each image supports both `linux/amd64` and `linux/arm64` platforms.

### Monitoring

- View build progress in the Actions tab of your GitHub repository
- Each job shows detailed logs for debugging
- Failed builds will send notifications (if configured)
- Build artifacts are automatically cleaned up after 1 day

### Adding New PHP Versions

To add a new PHP version (e.g., PHP 9.0):

1. Create the Dockerfile: `php/src/90/Dockerfile`
2. Update the matrix in `build-php-images.yml`:
   ```yaml
   php-version: ['81', '82', '83', '84', '85', '90']
   ```
3. Manually trigger the GitHub Action
