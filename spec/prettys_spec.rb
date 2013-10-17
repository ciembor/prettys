require 'prettys'

describe 'Prettys' do
  context '.prettys' do

    it { should respond_to(:prettys) }

  end
end

describe "Object" do

  subject { Object.new }

  describe ".prettys" do

    it 'should call Prettys.prettys' do
      Prettys::Core.should_receive(:prettys)
      prettys
    end

  end
end