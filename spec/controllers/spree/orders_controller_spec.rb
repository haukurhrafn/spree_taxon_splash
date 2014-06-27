require 'spec_helper'

describe Spree::OrdersController do
  before do 
    @products = []
    3.times do
      @products << FactoryGirl.create(:product)
    end

    @user = FactoryGirl.create :user
  end

  let(:products) { @products }
  let(:user) { @user }

  it "should delete variants when quantity is zero" do
    order = controller.current_order(true)
    order.line_items.should == []

    variants_params = products.inject({}) { |h, p| h.merge({ "#{p.master.id}" => h.values.max.to_i + 1 }) }
    response = spree_post :bundle_populate, "variants" => variants_params, "update" => ""

    response.code.should == "302"
    order.reload.line_items.reload.should_not == []
    products.each_with_index do |p, index|
      order.line_items.detect { |l| l.variant.id == p.master.id }.quantity.should == index + 1
    end

    # 0 should remove items
    variants_params[products.first.master.id] = "0"
    variants_params[products.last.master.id] = "0"
    spree_post :bundle_populate, "variants" => variants_params, "update" => ""
    order.reload.line_items.count.should == 1
  end

  it "should redirect when checkout button is pressed" do
    
  end
end