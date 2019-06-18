# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ENV['ELASTICSEARCH_URL'],
    retry_on_failure: true,
    transport_options: { 
      request: { timeout: 250 },
      ssl: {
        ca_path: '/usr/lib/ssl',
        version: :TLSv1_2,
        verify: false
      }
    }
  )
