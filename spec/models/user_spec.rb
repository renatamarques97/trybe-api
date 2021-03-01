require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:displayName) }
  it { is_expected.to validate_presence_of(:email) }

  describe "email validations" do
    context "when email is the same" do
      before do
        create(:user, email: "sample@email.com")
      end

      it { is_expected.not_to allow_value("sample@email.com").for(:email) }
    end

    context "invalid email format" do
      it { is_expected.not_to allow_value("sampleemail.com").for(:email) }
    end

    context "valid email format" do
      it { is_expected.to allow_value("sample@email.com").for(:email) }
    end
  end

  describe "#generate_jwt" do
    context "when token is successfully generated" do
      it "token is present" do
        expect(described_class.new.generate_jwt).to be_present
      end
    end
  end
end
