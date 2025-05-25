class Organizations::Staff::FaqsController < Organizations::BaseController
  layout "dashboard"
  before_action :set_faq, only: %i[show edit update destroy]

  def index
    authorize!
    @faqs = authorized_scope(Faq.all)
  end

  def new
    authorize!
    @faq = Faq.new
  end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    authorize!
    @faq = Faq.new(faq_params)

    if @faq.save
      redirect_to staff_faqs_url, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @faq.update(faq_params)
        format.html { redirect_to staff_faqs_url, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:alert] = t(".error") }
      end
    end
  end

  def destroy
    @faq.destroy!
    respond_to do |format|
      format.html { redirect_to staff_faqs_url, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private

  def set_faq
    @faq = Faq.find(params[:id])

    authorize! @faq
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_faqs_path, alert: t(".error")
  end

  def faq_params
    params.require(:faq).permit(:question, :answer, :order)
  end
end
