describe Radical::Application do
  let(:app) { Radical::Application.new }
  let(:response) { app.call(request) }

  context 'when valid request made' do
    context 'and a route matches request' do
      let(:request) { Rack::MockRequest.env_for('/', params: { route: ['get.name'] }) }
      let(:router) { double(route: { name: 'Luke' }) }
      before(:each) { app.router = router }

      context 'then the response status' do
        subject { response.status }
        it { is_expected.to eq(200) }
      end

      context 'then the response body' do
        subject { response.body.first }
        it { is_expected.to eq(JSON.dump(name: 'Luke')) }
      end

      context 'then the application' do
        before(:each) { response }

        it 'should forward request to router with params' do
          expect(router).to have_received(:route).with([[:get, :name]])
        end
      end
    end

    context 'and no route matches' do
      let(:request) { Rack::MockRequest.env_for('/', params: { route: ['get.nothing'] }) }

      context 'then the response status' do
        subject { response.status }
        it { is_expected.to eq(404) }
      end

      context 'then the response body' do
        subject { JSON.parse(response.body.first) }
        it { is_expected.to include('error' => a_kind_of(String)) }
      end
    end
  end

  context 'when request invalid' do
    let(:request) { Rack::MockRequest.env_for('/') }

    context 'then the response status' do
      subject { response.status }
      it { is_expected.to eq(400) }
    end

    context 'then the response body' do
      subject { JSON.parse(response.body.first) }
      it { is_expected.to include('error' => a_kind_of(String)) }
    end
  end
end