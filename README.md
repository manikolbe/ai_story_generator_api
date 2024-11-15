# AI Story Generator API

The **AI Story Generator API** is a serverless application designed to generate stories based on user prompts using AI. It leverages AWS services such as Lambda, API Gateway and Bedrock for scalable and efficient deployment.

Under the hood it uses `anthropic.claude-3-5-sonnet-20240620-v1:0` LLM model from Anthropic to generate the story.

Terraform is used for infrastructure provisioning, ensuring the setup is reproducible and manageable.

---

## Features

- **GenAI-Powered Story Generation**: Generate engaging stories based on user-provided prompts.
- **Serverless Architecture**: Powered by AWS Lambda for cost-effective scaling.
- **Infrastructure as Code**: Terraform scripts for automated infrastructure deployment.
- **API Gateway Integration**: Seamless API exposure for client applications.

---

## Project Structure

```plaintext
ai_story_generator_api-main/
├── LICENSE              # Licensing information
├── .gitignore           # Specifies untracked files for Git
├── src/                 # Source code for the application
│   └── main.py          # Main application logic
├── terraform/           # Terraform configuration files
│   ├── api-gateway.tf   # API Gateway configuration
│   ├── lambda.tf        # AWS Lambda configuration
│   ├── output.tf        # Output variables
│   ├── variables.tf     # Input variable definitions
│   └── variables.tfvars # Input variable values
```

---

## Prerequisites

- **AWS Account**: Ensure access to AWS with sufficient permissions to deploy Lambda, API Gateway and Bedrock.
- **AWS Account**: Enable access to anthropic.claude-3-5-sonnet-20240620-v1:0` LLM model on Bedrock Web UI
- **Terraform**: Installed on your local machine. ([Install Terraform](https://www.terraform.io/downloads))
- **Python**: Python 3.12 or later installed locally. ([Download Python](https://www.python.org/downloads/))

---

## Setup and Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/manikolbe/ai_story_generator_api.git
cd ai_story_generator_api
```

### 2. Configure AWS Credentials

Ensure AWS credentials are configured on your local machine for Terraform to access AWS resources.

### 3. Set Up Variables

Modify `terraform/variables.tfvars` with your desired values:

```hcl
project_name = "story_teller_genai_app"
owner        = "YourName"
```

### 4. Deploy with Terraform

Initialize and apply the Terraform configuration:

```bash
cd terraform
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
```

Confirm the deployment and note the API Gateway endpoint from the Terraform output.

---

## Running the Application

On successful installation, terraform will print the api endpoint url.
for example:
`api_endpoint = "https://myurl.execute-api.us-east-1.amazonaws.com"`

### API Endpoint

After deployment, use the API Gateway endpoint to interact with the application. Send a `POST` request with the following payload:

you can test the api endpoint by calling the following curl command

```bash
curl -X POST "<your api endpoint>/generate" -H "Content-Type: application/json" -d '{"prompt":"Alice in wonderland"}'
```

The response will include a generated story based on the provided prompt like:
`Once upon a time, there was a curious little girl named Alice. One day, while sitting by a tree, she saw a white rabbit in a waistcoat hurrying by. 'I'm late, I'm late!' the rabbit cried. Intrigued, Alice followed the rabbit and tumbled down a deep rabbit hole. When she landed, she found herself in a magical world called Wonderland. There, she met all sorts of strange characters: a Mad Hatter who loved tea parties, a grinning Cheshire Cat who could disappear, and a Queen of Hearts who loved to shout 'Off with their heads!' Alice had many exciting adventures in this topsy-turvy world, growing big and small by eating magical cakes and drinking special potions. In the end, she woke up under the tree, wondering if it had all been a wonderful dream.`

---

### To delete all AWS resources

```bash
terraform destroy -var-file=variables.tfvars -auto-approve
```

---

## License

This project is licensed under the terms of the [LICENSE](./LICENSE) file.

---

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

---
