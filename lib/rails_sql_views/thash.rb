module RailsSqlViews
  # A TSort-able hash. See http://stdlib.rubyonrails.org/libdoc/tsort/rdoc/classes/TSort.html
  class THash < Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end
end
