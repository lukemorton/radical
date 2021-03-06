describe Radical::Typed::Hash do
  context 'when given correct data type' do
    subject { Radical::Typed::Hash[name: String].new(name: 'Luke') }
    it { is_expected.to include(name: 'Luke') }
  end

  context 'when given incorrect data type' do
    subject { Radical::Typed::Hash[name: String].new(name: 10) }
    it { is_expected.to include(name: '10') }
  end

  context 'when given another typed hash type' do
    let(:address_type) { Radical::Typed::Hash[number: String] }
    subject { Radical::Typed::Hash[address: address_type].new(address: { number: 10 }) }
    it { is_expected.to include(address: a_hash_including(number: '10')) }
  end
end
