# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    host: ENV['ELASTICSEARCH_URL'],
    retry_on_failure: true,
    transport_options: {
      request: { timeout: 250 },
      ssl: {
        min_version: OpenSSL::SSL::SSL3_VERSION,
        max_version: OpenSSL::SSL::TLS1_2_VERSION,
        ca_path: '/usr/lib/ssl'
      }
    }
  )
