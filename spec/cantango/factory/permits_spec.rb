require 'spec_helper'
require 'fixtures/models'

CanTango.config.debug.set :on

class AdminPermit < CanTango::Permit::UserType
  def initialize ability
    super
  end

  protected

  def calc_rules
  end
end

describe CanTango::Factory::Permits do
  before do    
    @user = User.new 'kris', 'kris@mail.ru'
    @ua = UserAccount.new @user
    @user.account = @ua
    @ability = CanTango::Ability::Base.new @user
    @factory = CanTango::Factory::Permits.new @ability, :user_type
  end

  subject { @factory }

  describe 'attributes' do
    it "should have an ability" do
      subject.ability.should be_a(CanTango::Ability::Base)
    end
  end

  describe '#create' do
    it 'should build a list of permits' do
      subject.create.first.should be_a AdminPermit
    end
  end
end
