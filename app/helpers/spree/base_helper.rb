module Spree::BaseHelper

  def cart_link
    return new_order_url if session[:order_id].blank?
    return edit_order_url(Order.find_or_create_by_id(session[:order_id]))
  end

  def add_product_link(text, product) 
    link_to_remote text, {:url => {:controller => "cart", 
              :action => "add", :id => product}}, 
              {:title => "Add to Cart", 
               :href => url_for( :controller => "cart", 
                          :action => "add", :id => product)} 
  end 
  
  def remove_product_link(text, product) 
    link_to_remote text, {:url => {:controller => "cart", 
                       :action => "remove", 
                       :id => product}}, 
                       {:title => "Remove item", 
                         :href => url_for( :controller => "cart", 
                                     :action => "remove", :id => product)} 
  end 
  
  def todays_short_date
    utc_to_local(Time.now.utc).to_ordinalized_s(:stub)
  end
 
  def yesterdays_short_date
    utc_to_local(Time.now.utc.yesterday).to_ordinalized_s(:stub)
  end  
  

  # human readable list of variant options
  def variant_options(v, allow_back_orders = Spree::Config[:allow_backorders], include_style = true)
    list = v.option_values.map { |ov| "#{ov.option_type.presentation}: #{ov.presentation}" }.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
    list = include_style ? "<span class =\"out-of-stock\">(" + t("out_of_stock") + ") #{list}</span>" : "#{t("out_of_stock")} #{list}" unless (v.in_stock or allow_back_orders)
    list
  end  
  
  def mini_image(product)
    if product.images.empty?
      image_tag "noimage/mini.jpg"  
    else
      image_tag product.images.first.attachment.url(:mini)  
    end
  end

  def small_image(product)
    if product.images.empty?
      image_tag "noimage/small.jpg"  
    else
      image_tag product.images.first.attachment.url(:small)  
    end
  end

  def product_image(product)
    if product.images.empty?
      image_tag "noimage/product.jpg"  
    else
      image_tag product.images.first.attachment.url(:product)  
    end
  end
  
  def meta_data_tags
    return unless self.respond_to?(:object) && object
    "".tap do |tags|
      if object.respond_to?(:meta_keywords) and object.meta_keywords.present?
        tags << tag('meta', :name => 'keywords', :content => object.meta_keywords) + "\n"
      end
      if object.respond_to?(:meta_description) and object.meta_description.present?
        tags << tag('meta', :name => 'description', :content => object.meta_description) + "\n"
      end
    end
  end
  
end
