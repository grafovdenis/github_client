# github_client

A simplified version of GitHub client with following features:

- Authorization through GitHub [Web application flow](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow).
- Repository search implemented both using [REST API](https://docs.github.com/en/rest) and [GraphQL API](https://docs.github.com/en/graphql). The app could be compiled with REST or GraphQL client using build params.

## Configuration

For the proper work, you'll need to create `config.json` file in the root of the repository with the following content.

```json
{
    "GITHUB_CLIENT_ID": "YOUR_CLIENT_ID",
    "GITHUB_CLIENT_SECRET": "YOUR_CLIENT_SECRET"
}
```

For more details please refer to [GitHub App Documentation](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-user-access-token-for-a-github-app).

Another part of the configuration is defining a GitHub API client: REST or GQL.

Configuration examples could be found in [launch.json](/.vscode/launch.json) file.

## Architecture

The project follows Clean Architecture. The source code is divided into 3 modules: auth, core and search.
Each module may contain `data`, `domain` and `screens` folders.

### Data

Data layer contains data-specific models, repositories and clients, which interacts with the API or the platform.

### Domain

Domain layer contains use cases, which interact with various repositories.

### Screens

Screens are the UI part of the application, they interact with the use cases.

## Testing

The app has 96.6% (173 of 179 lines) code coverage.

You can verify it by running the `check_coverage.sh` script.
