class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  # protect_from_forgery unless: -> { request.format.json? }

  def health
    render json: {}
  end

  def create_order
    order = params
    job = order_to_job(order);
    job_response = create_job(job);
    # new_order = job_to_order(job_response)

    render json: job_response
  end

  def create_order_http_delay
    order = params
    job = order_to_job(order);
    job_response = create_job_dalay(job);
    new_order = job_to_order(job_response)

    render json: new_order
  end

  def create_order_http_random_delay
    order = params
    job = order_to_job(order);
    job_response = create_job_random_dalay(job);
    new_order = job_to_order(job_response)

    render json: new_order
  end

  private

  def order_to_job(order)
    {
      job: {
        pickups: [
          {
            address: order.dig(:package,:collect_task, :address, :street_name),
          },
        ],
        dropoffs: [
          {
            client_reference: order.dig(:package,:reference),
            package_type: order.dig(:package,:dimensions,:size),
            address: order.dig(:package,:deliver_task,:address,:street_name),
            contact: {
              contact_phone: order.dig(:package,:dimensions,:size),
            },
          },
        ],
      },
    }
  end

  def create_job_random_dalay(payload)
    begin
      HTTParty.get('https://dummy-api.beta.stuart-apps.solutions/api/foo/bar');
    rescue
      Rails.logger.error("[Error] https://dummy-api.beta.stuart-apps.solutions/api/foo/bar")
    end
    create_job(payload)
  end

  def create_job_dalay(payload)
    delay = ENV.fetch('HTTP_DELAY_IN_SECONDS', 1)
    HTTParty.get("https://httpbin.org/delay/#{delay}");
    create_job(payload)
  end

  def create_job(payload)
    job = payload[:job]
    dropoff = job[:dropoffs][0];
    pickup = job[:pickups][0];

    {
      id: 100432273,
      status: 'in_progress',
      package_type: dropoff[:package_type],
      pickup_at: '2023-01-25T12:52:00.000+01:00',
      deliveries: [
        {
          id: 100515659,
          status: 'waiting_at_dropoff',
          picked_at: '2023-01-25T12:50:34.000+01:00',
          delivered_at: nil,
          client_reference: dropoff[:client_reference],
          package_description: nil,
          package_type: dropoff[:package_type],
          pickup: {
            id: 2598682,
            address: {
              street: pickup[:address],
            },
          },
          dropoff: {
            id: 2598683,
            address: {
              street: dropoff[:address],
            },
            contact: {
              phone: dropoff[:contact][:contact_phone],
              company_name: nil,
              email: nil,
            },
          },
        },
      ],
    }
  end

  def job_to_order(job_response)
    delivery = job_response[:deliveries][0];

    {
      package: {
        reference: delivery[:client_reference],
      },
    }
  end
end
