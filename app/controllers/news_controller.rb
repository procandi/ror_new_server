class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  #use for android search by title. @xieyinghua
  def search_by_title
    title=params[:id]
    @news=News.where("title like '%#{title}%'").order('postdate desc, posttime desc')

    respond_to do |format|
      if @news!=nil
        format.html { render :index }
        format.json { render json: @news.limit(100), status: :ok }
      else
        @news = News.all
        format.html { render :index }
        format.json { render json: nil, status: :ok }
      end
    end
  end

  #use for android search by id. @xieyinghua
  def search_by_id
    id=params[:id]
    @news=News.where("id>=#{id}-10").order('postdate desc, posttime desc')

    respond_to do |format|
      if @news!=nil
        format.html { render :index }
        format.json { render json: @news.limit(100), status: :ok }
      else
        @news = News.all
        format.html { render :index }
        format.json { render json: nil, status: :ok }
      end
    end
  end


  # GET /news_by_title
  # GET /news.json
  def index_by_title
    title=params[:id]

    sql="title like '%#{title}%'"
    @news = News.all.where(sql).order('postdate desc, posttime desc')

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @news.limit(100), status: :ok }
    end
  end

  # GET /news_by_title
  # GET /news.json
  def index_by_tab
    #search from tab first
    tsort=params[:id]
    tab=Tab.all.where("tsort=#{tsort}").first

    #get news by tab name
    sql="tab='#{tab.tname}'"
    @news = News.all.where(sql).order('postdate desc, posttime desc')

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @news.limit(100), status: :ok }
    end
  end

  # GET /news_by_udid
  # GET /news.json
  def index_by_udid
    udid_list=params[:id]
    udid=udid_list.split(',')
    
    sql=''
    udid.each_with_index(){|v,i|
      if i==0
        sql+="id=#{udid[i]} "
      else
        sql+="or id=#{udid[i]} "
      end
    }

    @news = News.all.where(sql).order('postdate desc, posttime desc')

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @news.limit(100), status: :ok }
    end
  end

  # GET /news
  # GET /news.json
  def index
    @news = News.all.order('postdate desc, posttime desc')

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @news.limit(100), status: :ok }
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
  end

  # GET /news/new
  def new
    @news = News.new

    @tab = Tab.all.map{|tab| [tab.tname,tab.tname]}
  end

  # GET /news/1/edit
  def edit
    @tab = Tab.all.map{|tab| [tab.tname,tab.tname]}
  end

  # POST /news
  # POST /news.json
  def create
    #p 'jiajfijewaiofjewaiofjweaoif'
    #p params
    if params[:cros]!='y'
      #create from page query. @xieyinghua
      @news = News.new(news_params)
    else
      #create from cros post. @xieyinghua
      new_news_params=Hash.new
      new_news_params[:postdate]=params[:postdate]
      new_news_params[:posttime]=params[:posttime]
      new_news_params[:title]=params[:title]
      new_news_params[:body]=params[:body]
      new_news_params[:tab]=params[:tab]
      
      
      picture_path_params = params[:picture]
      #create a new tempfile named fileupload
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(picture_path_params))
     
      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => 'cool1.jpg', :original_filename => 'cool2.jpg') 
     

      new_news_params[:picture]=uploaded_file



      @news=News.new(new_news_params)
    end

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    if params[:cros]=='y'
      #update from cros post. @xieyinghua
      new_news_params=params
      new_news_params[:postdate]=params[:postdate]
      new_news_params[:posttime]=params[:posttime]
      new_news_params[:title]=params[:title]
      new_news_params[:body]=params[:body]
      new_news_params[:tab]=params[:tab]

      
      picture_path_params = params[:picture]
      #create a new tempfile named fileupload
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(picture_path_params))
     
      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => 'cool1.jpg', :original_filename => 'cool2.jpg') 
     
     
      new_news_params[:picture]=uploaded_file


      news_params=new_news_params
    else
      #update from page post. @xieyinghua
      news_params=params[:news]


      #need set value one by one, i not sure why. @xieyinghua
      new_news_params=Hash.new
      new_news_params[:postdate]="#{news_params['postdate(1i)']}-#{news_params['postdate(2i)']}-#{news_params['postdate(3i)']}"
      new_news_params[:posttime]="#{news_params['posttime(4i)']}:#{news_params['posttime(5i)']}:00"
      new_news_params[:title]=news_params[:title]
      new_news_params[:body]=news_params[:body]
      new_news_params[:tab]=news_params[:tab]
      new_news_params[:picture]=news_params[:picture]


      news_params=new_news_params
    end

    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    if params[:cros]=='y'
      #create from cros post. @xieyinghua
      id=params[:id]
      @news=News.where("id='#{id}'").first
    end

    @news.destroy
    respond_to do |format|
      format.html { redirect_to news_index_url, notice: 'News was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:postdate, :posttime, :title, :body, :picture, :tab)
    end
end
