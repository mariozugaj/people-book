# frozen_string_literal: true

Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ENV['ELASTICSEARCH_URL'],
    retry_on_failure: true,
    transport_options: { 
      request: { timeout: 250 },
      ssl: { ca_file: '/usr/lib/ssl/certs/ca-certificates.crt' } 
    }
  )
