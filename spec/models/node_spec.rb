require 'rails_helper'

RSpec.describe Node, type: :model do
  describe 'ancestry' do
    context 'with child' do
      let(:parent) { FactoryGirl.create(:node) }
      let(:child)  { FactoryGirl.create(:node, parent: parent) }

      it { expect(parent.children).to match_array([child]) }
    end

    context 'has parent' do
      let(:parent) { FactoryGirl.create(:node) }
      let(:child)  { FactoryGirl.create(:node, parent: parent) }

      it { expect(child.parent).to eq(parent) }
    end
  end
end
