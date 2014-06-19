# Source: http://blog.leshill.org/blog/2009/08/05/update-for-stub-chain-for-mocha.html

module StubChainMocha
  module Object
    def stub_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        stubs(methods.shift).returns(next_in_chain)
        next_in_chain.stub_chain(*methods)
      else
        stubs(methods.shift)
      end
    end
  end
end

Object.send(:include, StubChainMocha::Object)
