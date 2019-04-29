class ManageEndoController < ApplicationController
	before_action :set_scopy, only: [:editrfidtag, :updaterfidtag, :showrfidtag, :editstatus, :updatestatus, :showstatus]	 # need in one line. @xieyinghua

	def rfidtag
		@scopies=Scopy.all.order('sid asc')
	end
	def editrfidtag
	end
	def updaterfidtag
		respond_to do |format|
	      if @scopy.update(scopy_params)
	        format.html { render :showrfidtag, notice: notice }
	        format.json { render :showrfidtag, status: :ok, location: @scopy }
	      else
	        format.html { render :editrfidtag }
	        format.json { render json: @scopy.errors, status: :unprocessable_entity }
	      end
  		end
	end
	def showrfidtag
	end


	def status
		@scopies=Scopy.all.order('sid asc')
	end
	def editstatus
	end
	def updatestatus
		respond_to do |format|
	      if @scopy.update(scopy_params)
	        format.html { render :showstatus, notice: notice }
	        format.json { render :showstatus, status: :ok, location: @scopy }
	      else
	        format.html { render :editstatus }
	        format.json { render json: @scopy.errors, status: :unprocessable_entity }
	      end
  		end
	end
	def showstatus
	end



	private
		# Use callbacks to share common setup or constraints between actions.
		def set_scopy
			@scopy = Scopy.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def scopy_params
			params.require(:scopy).permit(:rid, :pid, :cid, :mid, :sid, :slabel, :sname, :sclass, :status)
		end
end
