module ActiveSupport
  module Cache
    class Store
      # Fetches data from the cache, using the given ids and ids_to_keys_proc.
      # If there is data in the cache with the given keys,
      # then that data is returned.
      # Otherwise, the supplied block is called for ids for which there was no
      # data, and the result will be written to the cache and returned
      # as ids -> values hash.
      # Ids can be any even composite identifiers.
      #
      # Options are passed to the underlying cache implementation.
      #
      # Returns hash of id -> value of passed ids. For example:
      #
      #   def ids_to_keys(ids)
      #     ids.each_with_object({}) do |id, memo|
      #       memo[id] = "key_base/id_#{id}"
      #     end
      #   end
      #   cache.write("key_for_1", "value_for_1")
      #   cache.fetch_and_process_multi(ids_to_keys([1, 2]) do |uncached_ids|
      #     uncached_ids.each_with_object({}) do |id, memo|
      #       memo[id] = "fallback_value_for_#{id}"
      #     end
      #   end
      #   # => { 1 => "value_for_1", 2 => "fallback_value_for_2" }
      #
      def fetch_and_process_multi(ids_to_keys, options = {})
        options = merged_options(options)
        return {} if ids_to_keys.blank?

        keys_to_ids = ids_to_keys.invert

        cached_keys_to_values = read_multi(*keys_to_ids.keys, options)
        cached_ids_to_values =
          cached_keys_to_values.each_with_object({}) do |(key, value), memo|
            memo[keys_to_ids[key]] = value
          end

        if cached_ids_to_values.size == ids_to_keys.size
          return cached_ids_to_values
        end

        uncached_ids = ids_to_keys.keys - cached_ids_to_values.keys
        uncached_ids_to_values = yield(uncached_ids)
        uncached_ids_to_values.each do |id, value|
          write(ids_to_keys[id], value, options)
        end

        cached_ids_to_values.merge!(uncached_ids_to_values)
      end
    end
  end
end
