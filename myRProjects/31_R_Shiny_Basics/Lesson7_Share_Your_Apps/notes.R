# ============================================================
# 31 - R Shiny Basics
# Lesson 7: Share Your Apps
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson7/
#
# This lesson is conceptual rather than code-based -- it's a survey of
# ways to distribute a finished Shiny app. Kept here as a notes file
# rather than a runnable app.
# ============================================================

# ---- Option 1: Share as an R script -------------------------
# Recipients need R (+ Shiny) installed locally. Hand them the app
# directory (app.R plus any data/ or helpers.R it depends on) and they
# launch it by calling shiny's runApp with the app directory name, e.g.
# runApp given "app-name".

# ---- Option 2: Share as a web page ---------------------------
# The app is hosted at a URL; recipients just need a browser, no R
# install required. This is the more common path for real users.

# ---- Hosting an R script online (still requires R locally) ----

# runUrl(): zip the app directory, host the zip anywhere on the web,
# recipients run shiny's runUrl pointed at that zip's URL.

# runGitHub(): free hosting via a public GitHub repo; recipients run
# shiny's runGitHub given the repository name and username.

# runGist(): anonymous, no-signup sharing via gist.github.com;
# recipients run shiny's runGist given the gist number.

# ---- Web-based hosting (no R required by the end user) --------

# shinyapps.io -- Posit's hosted service. Deploy straight from an R
# session once the rsconnect package is installed and configured, by
# calling rsconnect's deployApp with the path to the app directory.

# Shiny Server -- free, open-source, self-hosted on Linux. Good for
# running many apps behind an internal firewall.

# Posit Connect -- paid, enterprise-grade self-hosted option: adds
# authentication, SSL, admin tooling, and support on top of what
# Shiny Server offers.

# ---- Takeaway --------------------------------------------------
# Pick the sharing method based on the audience:
#   - other R users on the same team -> runGitHub or runUrl
#   - a quick anonymous demo         -> runGist
#   - the general public / no-R-installed users -> shinyapps.io,
#     Shiny Server, or Posit Connect depending on scale/budget/security
#     requirements.
