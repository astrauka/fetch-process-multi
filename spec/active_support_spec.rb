require 'spec_helper'

RSpec.describe ActiveSupport::Cache::Store do
  describe '.fetch_and_process_multi' do
    subject do
      cache.fetch_and_process_multi(ids_to_keys(ids), options) do |uncached_ids|
        estimator_proc.call(uncached_ids)
      end
    end
    let(:cache) { Rails.cache }
    let(:ids) { [not_written_id, written_id] }
    let(:written_id) { 1 }
    let(:not_written_id) { 2 }
    let(:estimator_proc) { double :call }
    let(:written_value) { 10 }
    let(:not_written_value) { 20 }
    let(:options) { { namespace: 'app_' } }

    before do
      allow(cache).to receive(:read_multi).and_return(
        key_for_id(written_id) => written_value,
      )
    end

    it 'uses cached data and calculates missing' do
      expect(estimator_proc).to receive(:call)
        .with([not_written_id])
        .and_return(not_written_id => not_written_value)

      expect(cache).to receive(:write)
        .with(key_for_id(not_written_id), not_written_value, options)
        .and_call_original

      expect(subject).to eq(
        not_written_id => not_written_value,
        written_id => written_value,
      )
    end

    context 'for no missing data' do
      before do
        allow(cache).to receive(:read_multi).and_return(
          key_for_id(written_id) => written_value,
          key_for_id(not_written_id) => not_written_value,
        )
      end

      it 'does not invoke calculation' do
        expect(estimator_proc).not_to receive(:call)

        expect(subject).to eq(
          not_written_id => not_written_value,
          written_id => written_value,
        )
      end
    end

    context 'for empty list' do
      let(:ids) { [] }
      it { is_expected.to eq({}) }
    end

    private

    def ids_to_keys(ids)
      ids.each_with_object({}) { |id, memo| memo[id] = "key_base/id_#{id}" }
    end

    def key_for_id(id)
      ids_to_keys([id]).values.first
    end
  end
end
