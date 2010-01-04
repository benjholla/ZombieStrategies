class TwitterComputationsController < ApplicationController
  
  before_filter :login_required, :except => :show
  
  # GET /twitter_computations
  # GET /twitter_computations.xml
  def index
    @twitter_computations = TwitterComputation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_computations }
    end
  end

  # GET /twitter_computations/1
  # GET /twitter_computations/1.xml
  def show
    @twitter_computation = TwitterComputation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @twitter_computation }
    end
  end

  # GET /twitter_computations/new
  # GET /twitter_computations/new.xml
  def new
    @twitter_computation = TwitterComputation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @twitter_computation }
    end
  end

  # GET /twitter_computations/1/edit
  def edit
    @twitter_computation = TwitterComputation.find(params[:id])
  end

  # POST /twitter_computations
  # POST /twitter_computations.xml
  def create
    
    @twitter_trend = TwitterTrend.find(params[:twitter_trend_id])
    @twitter_computation = @twitter_trend.twitter_computations.create!(params[:twitter_computation])

    respond_to do |format|
      if @twitter_computation.save
        flash[:notice] = 'Created Twitter Computation.'
        format.html { redirect_to(twitter_trends_url + "/" + @twitter_computation.twitter_trend_id.to_s) }
        format.xml  { render :xml => @twitter_computation, :status => :created, :location => @twitter_computation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @twitter_computation.errors, :status => :unprocessable_entity }
      end
    end
  end
  


  # PUT /twitter_computations/1
  # PUT /twitter_computations/1.xml
  def update
    @twitter_computation = TwitterComputation.find(params[:id])

    respond_to do |format|
      if @twitter_computation.update_attributes(params[:twitter_computation])
        flash[:notice] = 'Updated Twitter Computation.'
        format.html { redirect_to(twitter_trends_url + "/" + @twitter_computation.twitter_trend_id.to_s) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @twitter_computation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_computations/1
  # DELETE /twitter_computations/1.xml
  def destroy
    @twitter_computation = TwitterComputation.find(params[:id])
    @twitter_computation.destroy

    respond_to do |format|
      format.html { redirect_to(twitter_computations_url) }
      format.xml  { head :ok }
    end
  end
end
