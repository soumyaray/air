library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  filter_sensitive_data = list(
    "<<<api_key>>>" = air:::get_key()$message,
    "<<<api_model>>>" = air:::get_key()$message
  ),
  dir = vcr::vcr_test_path("fixtures")
))
vcr::check_cassette_names()
