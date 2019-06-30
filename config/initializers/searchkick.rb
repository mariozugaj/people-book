# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ['localhost:9200', ENV['ELASTICSEARCH_URL']],
    retry_on_failure: true
  )
