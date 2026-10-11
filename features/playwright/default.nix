{ pkgs, ... }:
{
  # environment.systemPackages = [ pkgs.chromium ];

  environment.sessionVariables = {
    PLAYWRIGHT_MCP_BROWSER = "chromium";
    PLAYWRIGHT_MCP_EXECUTABLE_PATH = "${pkgs.chromium}/bin/chromium";
    PLAYWRIGHT_MCP_HEADLESS = "true";
  };
}
