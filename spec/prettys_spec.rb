require 'prettys'

describe 'Prettys' do
  context '.prettys' do
    it { should respond_to(:prettys) }
  end
  describe 'configuration' do
    it 'should have default format set to :json' do
      Prettys.format.should == :json
    end
    it 'should accept other formats' do
      Prettys.format = :yaml
      Prettys.format.should == :yaml
    end
    it 'shouldn\'t accept not supported formats' do
      expect { Prettys.format = :not_supported_format }.to raise_error(ArgumentError, 'Unsupported format.')
    end 
  end
end

describe 'Object' do
  subject { Object.new }
  describe '.prettys' do
    it 'should call Prettys.prettys' do
      Prettys.should_receive(:prettys).with(self)
      prettys
    end
  end
end