# GitHub Actions Workflows

## PHP Docker Images Build Workflow

This repository includes a GitHub Actions workflow (`build-php-images.yml`) that builds and pushes multi-platform PHP Docker images to Docker Hub.

### Features

- **Multi-platform builds**: Supports both AMD64 (Intel) and ARM64 (Apple Silicon) architectures
- **Distributed builds**: Uses matrix strategy to build images across multiple runners in parallel
- **Multiple PHP versions**: Currently builds PHP 8.2, 8.3, 8.4, 8.5, and 8.6
- **Manual trigger**: Run on demand via workflow dispatch

### Setup Requirements

Before using this workflow, you need to configure the following secrets in your GitHub repository:

1. Go to your repository settings → Secrets and variables → Actions
2. Add the following *Repository Secrets*:
   - `DOCKER_USERNAME`: Your personal Docker Hub username (organisations can't have logins/tokens)
   - `DOCKER_PASSWORD`: Your personal Docker Hub access token

### Workflow Triggers

This workflow is triggered manually via workflow dispatch.

When you run it, you can optionally specify a custom tag. This defaults to `latest`.

### Workflow Process

1. **Build Job**:
   - Creates a matrix of 10 build combinations (5 PHP versions × 2 platforms)
   - Each combination builds and pushes a platform-specific image by digest
   - Uploads build digests as temporary artifacts (retained for 1 day)

2. **Merge Job**:
   - Downloads digests from all platform builds for each PHP version
   - Creates multi-platform manifest lists using `docker buildx imagetools create`
   - Pushes final multi-platform images with tags like `wearepvtl/php-fpm-8.4:latest`

### Generated Images

The workflow creates PHP src images, eg. `wearepvtl/php-fpm-8.6:latest`

Each image supports both `linux/amd64` and `linux/arm64` platforms.

### Monitoring

- View build progress in the Actions tab of your GitHub repository
- Each job shows detailed logs for debugging
- Failed builds will send notifications (if configured)
- Build artifacts expire automatically after 1 day

### Adding New PHP Versions

To add a new PHP version (e.g., PHP 9.0):

1. Create the Dockerfile: `php/src/90/Dockerfile` (note: folder uses non-dotted version)
2. Add the version to both matrices in `build-php-images.yml`:
   ```yaml
   php-version: ['8.2', '8.3', '8.4', '8.5', '8.6', '9.0']
   ```
3. Manually trigger the GitHub Action
