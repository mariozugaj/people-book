# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    host: ENV['SEARCHBOX_SSL_URL'],
    retry_on_failure: true
  )
