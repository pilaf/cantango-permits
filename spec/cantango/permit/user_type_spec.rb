require 'spec_helper'
require 'fixtures/models'

class AdminPermit < CanTango::Permit::UserType
  def initialize ability
    super
  end

  protected

  def static_rules
    can :read, Article
  end
end


describe CanTango::Permit::UserType do
  before do
    @user = SimpleUser.new
    @ability = CanTango::Ability::Base.new @user
    @permit = AdminPermit.new @ability
  end

  subject { @permit }

  describe 'registration' do
    describe 'permit types' do
      specify { CanTango.config.permits.types.registered.should include(:user_type) }
    end

    describe 'permits of type' do    
      specify { CanTango.config.permits.registered_for(:user_type, :admin).should == AdminPermit }
    end
  end

  describe 'attributes' do
    it "should be the permit for the :admin user" do
      subject.permit_name.should == :admin
    end

    it "should have a user candidate" do
      subject.candidate.should be_a(SimpleUser)
    end

    it "should have a user subject" do
      subject.send(:user).should be_a(SimpleUser)
    end

    it "should have an ability" do
      subject.ability.should be_a(CanTango::Ability::Base)
    end
  end

  context 'config permits' do
    let(:permits) { CanTango.config.permits }

    describe 'disable Admin Permit' do
      before do
        permits.disable_for :user_type, [:admin, :editor]
      end

      it "should have an ability" do
        subject.disabled?.should be_true
      end
    end

    describe 'enable all Permits' do
      before do
        permits.enable_all!
      end

      it "should be disabled" do
        permits.disabled.should be_empty
        subject.disabled?.should be_false
      end
    end
  end
end