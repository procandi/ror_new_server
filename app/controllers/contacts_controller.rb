class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    if params[:cros]!='y'
      #create from page query. @xieyinghua
      @contact = Contact.new(contact_params)
    else
      #create from cros post. @xieyinghua
      new_contact_params=Contact.new
      new_contact_params[:name]=params[:name]
      new_contact_params[:phone]=params[:phone]
      new_contact_params[:reason]=params[:reason]
      new_contact_params[:email]=params[:email]
      new_contact_params[:message]=params[:message]

      @contact=Contact.new(new_contact_params)
    end

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    if params[:cros]=='y'
      #create from cros post. @xieyinghua
      id=params[:id]
      @contact=Contact.where("id='#{id}'").first
      @contact.name=params[:name]
      @contact.phone=params[:phone]
      @contact.reason=params[:reason]
      @contact.email=params[:email]
      @contact.message=params[:message]
    end

    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :phone, :reason, :email)
    end
end
