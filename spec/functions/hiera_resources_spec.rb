require 'spec_helper'

describe 'hiera_resources' do
  it 'test1 with a notify and full message' do
    should run.with_params('test1').and_return(
      {"notify" =>
        {"title 1" =>
          {"message" => "this is the first message stored in YAML"}
        }
      }
    )
  end

  it 'test with a notify and message from title' do
    should run.with_params('test2').and_return(
      {"notify" =>
        {"title 2" =>
          {}
        }
      }
    )
  end

  it 'test3 with a notify and message from title' do
    should run.with_params('test3').and_return(
      {"notify" =>
        {"title 3" =>
          {}
        }
      }
    )
  end

  it { should run.with_params('test').and_raise_error(Puppet::ParseError) }

  it 'test_defaults with a notify and default merge' do
    should run.with_params('test defaults',{'notify' => {'message' => 'This is a default message'}}).and_return(
      {"notify" =>
        {"title defaults" =>
          {"message" => 'This is a default message'}
        }
      }
    )
  end
end
