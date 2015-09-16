require 'rails_helper'

RSpec.describe CachedNode, type: :model do
  describe 'behavior' do
    before(:all) { @node = CachedNode.new(:value => 'node1', :id => 2).save }

    context 'be created' do
      it { expect(@node.present?).to eq(true) }
    end

    context 'appears in collection' do
      let(:nodes) { CachedNode.all }

      it { expect(nodes.map(&:uuid)).to match_array([@node.uuid]) }
    end

    context 'raise attributes error' do
      it do
        expect do
          CachedNode.new(:title => 'node1')
        end.to raise_exception(RedisRecord::Errors::WrongAttribute)
      end
    end

    context 'found record' do
      it { expect(CachedNode.find(@node.uuid).uuid).to eq(@node.uuid) }
    end

    context 'raise record not found' do
      it do
        expect do
          CachedNode.find(1111)
        end.to raise_exception(RedisRecord::Errors::RecordNotFound)
      end
    end

    context 'can destroy all records' do
      let(:action) { CachedNode.destroy_all }

      it do
        action
        expect(CachedNode.all).to match_array([])
      end
    end
  end

  describe 'ancestry' do
    context 'parent with id' do
      let!(:parent) { CachedNode.new(:value => 'parent', :id => 1).save }
      let!(:child)  { CachedNode.new(:value => 'child', :id => 2, :parent => parent).save }

      it { expect(parent.child_ids).to match_array([child.uuid]) }
      it { expect(child.parent_id).to eq(parent.id) }
    end

    context 'parent without id' do
      let!(:parent) { CachedNode.new(:value => 'parent').save }
      let!(:child)  { CachedNode.new(:value => 'child', :parent => parent).save }

      it { expect(parent.child_ids).to match_array([child.uuid]) }
      it { expect(child.parent_id).to eq(parent.uuid) }
    end

    context 'errors' do
      let(:parent) { CachedNode.new(:value => 'parent') }
      let(:child)  { CachedNode.new(:value => 'child').save }

      it { expect { child.parent = 1 }.to raise_exception(SmartAncestry::WrongParent) }
      it { expect { child.parent = parent }.to raise_exception(SmartAncestry::WrongParent) }
    end

    context 'root' do
      let(:root)         { CachedNode.new(:value => 'parent', :id => 1).save }
      let(:child)        { CachedNode.new(:value => 'child', :id => 2, :parent => root).save }
      let(:grand_child)  { CachedNode.new(:value => 'grand_child', :id => 3, :parent => child).save }

      it { expect(grand_child.root_id).to eq(root.id) }
    end
  end
end
