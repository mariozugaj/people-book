module Search
  class StatusUpdates < ApplicationSearch
    def query
      StatusUpdate.includes(author: :profile)
                  .ransack(text_cont: params)
                  .result
                  .limit(limit)
    end

    def result
      results(query,
              title: 'text.truncate(50)',
              image: 'image.url(:thumb)',
              url: 'status_update_path',
              description: 'author_name')
    end
  end
end
