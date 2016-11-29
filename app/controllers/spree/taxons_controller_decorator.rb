Spree::TaxonsController.class_eval do
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  old_show = instance_method(:show)

  define_method(:show) do
    @taxon = Spree::Taxon.friendly.find(params[:id])
    
    if @taxon.taxon_splash.nil?
      old_show.bind(self).()
    else
      old_show.bind(self).()
      render :template => 'spree/taxons/splash'
    end
  end
  
  #def taxon_params
  #  params.require(:user).permit(:taxon_id, :content)
  #end
end