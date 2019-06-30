# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ENV['ELASTICSEARCH_URL'],
    retry_on_failure: true
  )
