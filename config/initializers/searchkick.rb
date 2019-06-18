# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    host: ENV['ELASTICSEARCH_URL'],
    retry_on_failure: true,
    transport_options: {
      request: { timeout: 250 },
      ssl: {
        min_version: :TLSv1_2,
        ca_path: '/usr/lib/ssl'
      }
    }
  )
