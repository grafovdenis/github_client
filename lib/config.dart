class Config {
  final String githubClientId;
  final String githubClientSecret;

  const Config({
    this.githubClientId = const String.fromEnvironment('GITHUB_CLIENT_ID'),
    this.githubClientSecret =
        const String.fromEnvironment('GITHUB_CLIENT_SECRET'),
  });
}
