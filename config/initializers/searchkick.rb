Searchkick.client =
  Elasticsearch::Client.new(hosts: ['127.0.0.1:9200'],
                            retry_on_failure: true,
                            transport_options: { request: { timeout: 250 } })
