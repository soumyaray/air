library("vcr") # *Required* as vcr is set up on loading

with_stubbed_credentials({
  invisible(vcr::vcr_configure(
    filter_sensitive_data = list(
      "<<<api_key>>>" = air:::get_key() |> value(),
      "<<<api_model>>>" = air:::get_key() |> value()
    ),
    dir = vcr::vcr_test_path("fixtures")
  ))

  vcr::check_cassette_names()
})
