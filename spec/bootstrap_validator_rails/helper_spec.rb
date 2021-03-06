require 'rails_helper'

describe ActionView::Base do
  class HelperProduct
    include ActiveModel::Validations

    attr_accessor :title

    validates :title, presence: {message: 'This field is required'}
  end
  
  let(:product) { HelperProduct.new }
  let(:view) { described_class.new }

  describe '#bv_options_for' do
    it 'generates json options' do
      bv_options = view.bv_options_for(product)
      expect(bv_options).to eq(
        {
          fields: {
            'helper_product[title]' => {
              'validators' => {
                'notEmpty' => {
                  'message' => 'This field is required' 
                }
              }
            }
          }
        }.to_json.html_safe
      )
    end
  end

  describe '#bv_form_for' do
    it 'generates form tag using #bootstrap_form_for' do
      expect(view).to receive(:bootstrap_form_for).with(product, {builder: BootstrapValidatorRails::FormBuilder})
      view.bv_form_for(product)
    end
  end
end
