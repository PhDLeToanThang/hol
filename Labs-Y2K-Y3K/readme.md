# Phần 1. Luận điểm chung:



# Phần 2. Phân tích mở rộng:

## Bước 1. Cách tiếp cận Tư Duy Dữ liệu:

```python
from google import genai

client = genai.Client(api_key="Abcxyz")

response = client.models.generate_content(
    model="gemini-2.5-flash", contents="""
Tôi đã tải các tệp về: Đề cương các khóa học, Giáo trình một số môn học, Pentest, Cybersecurity, Security+, Cyber Analytics, Data Scientist, Power BI, MS-SQL Data warehouse, SIEM, ELK, Trivy scan, Wazuh, ElasticSearch, AI Private Local, AI Security, ISO 27001, CSA,
Tiêu chí An ninh an toàn kỹ thuật CNTT, EVE-NG Labs network, PNETLAB for Labs network, Kiến trúc giải pháp Ảo hóa, Điện toán đám mây, Cổng thông tin SharePoint, Email Exchange, Các bài thực hành và mô hình miêu tả các bước dựng Labs thực hành
trong thư mục: r'D:\Documents\Downloads\ebook_Labs\' và trong thư mục: r'D:\Documents\Downloads\ITInternalAuditBook\' và trong thư mục r'D:\Documents\GitHub\ai-llm\dataframework\' và trong thư mục r'D:\Documents\GitHub\ai-llm\Workshop_Training\', 
và trong thư mục r'D:\Documents\GitHub\ai-ml-dl\' và r'D:\Documents\GitHub\pendtesing_it-audit\'
và r'D:\Documents\GitHub\handonlabs\'.

Hãy viết cho tôi hàm python 3.11 Jupyter Notebook sao cho có thể đọc tất cả các tệp pdf, docx, md, txt, csv, xlsx nói trên và thực hiện 4 yêu cầu sau:

1. Dựa trên Tư duy Dữ liệu, hãy phân tích chi tiết và đầy đủ về đề xuất của tệp: r'D:\Documents\Downloads\ebook_Labs\Đề tài Xây dựng Hệ thống Labs-as-a-Service (LaaS) cho Đào tạo và Triển khai Công nghệ Thông tin.pdf', 
với các đánh giá mở rộng, giả thuyết, giả sử là đáp ứng được thực hiện được, theo xu thế của thị trường đào tạo và công nghệ mới áp dụng trong Doanh nghiệp hiện nay
để xác định các vấn đề còn thiếu trong đề xuất, cần điều chỉnh thêm về Đào tạo, PoC/Demo trong thực tế Doanh nghiệp? các chú trọng kỹ thuật, đầu tư nên tập trung vào 
hệ thống Labs nào? ngoài các môn đã nêu làm thí điểm thì còn những môn gì cần bổ sung? và hệ thống Labs thực tế cần đáp ứng chung là gì?

2. Dựa trên phân tích chi tiết và đầy đủ về đề xuất của tệp: r'D:\Documents\Downloads\ebook_Labs\Đề tài Xây dựng Hệ thống Labs-as-a-Service (LaaS) cho Đào tạo và Triển khai Công nghệ Thông tin.pdf' nói trên làm khung nội dung đối với Đào tạo và Giáo dục, 
- Sau đó, kèm với Phân loại các nhóm: Labs thực hành cho Đào tạo giáo dục: 
+ Phân loại: các Nhóm Bộ môn, 
+ Phân loại: các đối tượng học viên, vị trí vai trò nghiệp vụ, đối tượng Doanh nghiệp (nếu có).
+ Phân loại: Khóa học từ các phân tích trong các Thư mục đã nêu.
+ Phân loại: các Nhóm yêu cầu về hạ tầng thiết bị, 
ví dụ: máy chủ, GPU, máy trạm Workstation Client, Pi4/Pi5, AI Private Local, Data Analytics Platform, BigData, SharePoint, Exchange, CEH, Data Scientist...
K8s node, MS-SQL HA, vSphere ICM8, vRealize Automation 8x, vRealize Operation Suite 8x, VCF 5.x, VCF 9x, POD container, K3S IoT MQTT, Python Jupyterhub, DevSecOps CI/CD Pipeline Data
Git, LPi, Security+, CyberSecurity+, CyberAsk+... 
Lưu ý: Các hệ thống Labs đều làm thực hành Online qua Web HTML5 hoặc nhúng tích hợp với LMS (Moodle 3/4x) có thêm OTP/MFA tăng cường bảo mật users session/device.

3. Đối với các Bài toán Dự án Doanh nghiệp và phát triển theo yêu cầu Cá nhân muốn có dịch vụ thuê Labs:
+ Phân loại: Nhóm Doanh nghiệp,
+ Phân loại: lĩnh vực hoạt động Doanh nghiệp, nghiệp vụ của Doanh nghiệp (nếu có),
+ Phân loại: Các Chương trình đào tạo, tập huấn phù hợp với từng loại Doanh nghiệp (nếu có),
+ Phân loại: các công nghệ và môi trường phù hợp với các nhóm Doanh nghiệp.
+ Mục tiêu phổ biến: ví dụ là hỗ trợ đào tạo nội bộ Doanh nghiệp, nâng cao năng lực đội ngũ CNTT, tiết kiệm thời gian và tận dụng tối đa tài nguyên nội bộ sẵn có.
+ Viết các kịch bản, thử nghiệm, các bài thực hành labs theo nghiệp vụ của từng nhóm Doanh nghiệp.
+ Tóm tắt các PoC, Showcase, hoặc Case study có trong các nhóm Sách Mastering, Cookbook hoặc các tài liệu hướng dẫn cài đặt, triển khai.
Lưu ý: Các hệ thống Labs đều làm thực hành Online qua Web HTML5 hoặc nhúng tích hợp với LMS (Moodle 3/4x làm online elearning) có thêm OTP/MFA tăng cường bảo mật users session/device.

4. Hãy Lập ra bảng Dashboard insight: Danh sách các môn, Danh sách Khóa học, Danh sách các Labs, Cấu hình về Phần cứng, phần mềm đáp ứng tối thiểu, Mô hình Labs thực hành. 
Sau đó thêm phần So sánh các yêu cầu, tính năng, chức năng, các khả năng và các yêu cầu kỹ thuật của từng mô hình Labs, nhằm xác định yếu tố chung để quyết định xây dựng
đầu tư hệ thống Labs On-premise Local/Co-location từ hạ tầng ảo hóa đến các Containers, VM, Dockers, API, Database cho Labs đào tạo-giáo dục online và cho PoC/Demo theo yêu cầu của nhóm Doanh nghiệp.
    """
)
print(response.text)
```

## Bước 2. Phân tích tài liệu trong nhiều thư mục bằng Python 3.11+Jupyter notebook+ gemini2.5-flash

```python
!pip install pypdf python-docx openpyxl pandas langchain langchain-google-genai 
```

```python
### Code Jupyter Notebook

# Cài đặt thư viện cần thiết (chỉ chạy một lần)
import sys
# Bạn có thể cần gỡ cài đặt Ollama nếu không dùng nữa để tránh nhầm lẫn, nhưng không bắt buộc
# !{sys.executable} -m pip uninstall -y langchain_community # Gỡ các gói cũ nếu có xung đột
#!{sys.executable} -m pip install pypdf python-docx openpyxl pandas langchain langchain-google-genai 
# langchain-google-genai thay thế langchain_community cho Google
# !{sys.executable} -m pip install faiss-cpu # Tùy chọn, nếu muốn dùng FAISS cho RAG

import os
import re
import pandas as pd
from pypdf import PdfReader
from docx import Document as DocxDocument
from typing import List, Dict, Union, Any

# LangChain components
# Thay thế Ollama bằng ChatGoogleGenerativeAI
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.prompts import PromptTemplate
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.schema.document import Document as LangchainDocument

# --- 0. Cấu hình và Khởi tạo LLM ---

# Cấu hình đường dẫn thư mục
BASE_DIRS = [
    'D:/Documents/Downloads/ebook_Labs/',
    'D:/Documents/Downloads/ITInternalAuditBook/',
    'D:/Documents/GitHub/ai-llm/dataframework/',
    'D:/Documents/GitHub/ai-llm/Workshop_Training/',
    'D:/Documents/GitHub/ai-ml-dl/',
    'D:/Documents/GitHub/pendtesing_it-audit/',
    'D:/Documents/GitHub/ai-llm/',
    'D:/Documents/GitHub/handonlabs/'
]

# Đường dẫn đến tệp Đề tài LaaS cụ thể
# Sử dụng r'' cho đường dẫn để tránh vấn đề ký tự thoát, hoặc dùng dấu '/'
LAAS_PROPOSAL_PATH = r'D:\Documents\Downloads\ebook_Labs\Đề tài Xây dựng Hệ thống Labs-as-a-Service (LaaS) cho Đào tạo và Triển khai Công nghệ Thông tin.pdf'

# KHỞI TẠO LLM VỚI GOOGLE GEMINI
# Đặt API key của bạn vào biến môi trường hoặc điền trực tiếp vào đây
# Ví dụ: os.environ["GOOGLE_API_KEY"] = "YOUR_GOOGLE_API_KEY_HERE"
# Hoặc truyền thẳng vào constructor (ít khuyến nghị hơn vì lý do bảo mật)
# llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0.3, google_api_key="YOUR_GOOGLE_API_KEY_HERE")

# Ví dụ: Đặt API key vào biến môi trường trước khi chạy Jupyter cell này
# os.environ["GOOGLE_API_KEY"] = "Abcxyz" # THAY THẾ BẰNG API KEY CỦA BẠN!
llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0.3, google_api_key="Abcxyz") 
# Lưu ý: Model "gemini-2.5-flash" có thể là tên thử nghiệm hoặc chưa công khai rộng rãi.
# Nếu gặp lỗi, hãy thử "gemini-1.5-flash" hoặc "gemini-1.5-pro" nếu có quyền truy cập.


# Khởi tạo Text Splitter
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=4000, # Kích thước chunk phù hợp với context window của LLM
    chunk_overlap=500,
    length_function=len,
    is_separator_regex=False,
)

# --- 1. Hàm đọc tệp ---

def read_pdf(filepath: str) -> str:
    """Reads text content from a PDF file."""
    try:
        reader = PdfReader(filepath)
        text = ""
        for page in reader.pages:
            text += page.extract_text() if page.extract_text() else ""
        return text
    except Exception as e:
        print(f"Error reading PDF {filepath}: {e}")
        return ""

def read_docx(filepath: str) -> str:
    """Reads text content from a DOCX file."""
    try:
        doc = DocxDocument(filepath)
        return "\n".join([paragraph.text for paragraph in doc.paragraphs])
    except Exception as e:
        print(f"Error reading DOCX {filepath}: {e}")
        return ""

def read_md_txt(filepath: str) -> str:
    """Reads text content from MD or TXT file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"Error reading MD/TXT {filepath}: {e}")
        return ""

def read_csv(filepath: str) -> str:
    """Reads content from a CSV file into a string representation."""
    try:
        df = pd.read_csv(filepath)
        return df.to_csv(index=False) # Convert DataFrame to CSV string
    except Exception as e:
        print(f"Error reading CSV {filepath}: {e}")
        return ""

def read_xlsx(filepath: str) -> str:
    """Reads content from an XLSX file into a string representation."""
    try:
        xls = pd.ExcelFile(filepath)
        all_sheets_text = []
        for sheet_name in xls.sheet_names:
            df = pd.read_excel(filepath, sheet_name=sheet_name)
            all_sheets_text.append(f"Sheet: {sheet_name}\n{df.to_csv(index=False)}")
        return "\n\n".join(all_sheets_text)
    except Exception as e:
        print(f"Error reading XLSX {filepath}: {e}")
        return ""

def get_file_paths(base_dirs: List[str]) -> List[str]:
    """Recursively finds all supported file paths in given directories."""
    file_paths = []
    supported_extensions = ('.pdf', '.docx', '.md', '.txt', '.csv', '.xlsx')
    for base_dir in base_dirs:
        # Kiểm tra sự tồn tại của thư mục
        if not os.path.exists(base_dir):
            print(f"Warning: Directory not found: {base_dir}")
            continue
        for root, _, files in os.walk(base_dir):
            for file in files:
                if file.endswith(supported_extensions):
                    file_paths.append(os.path.join(root, file))
    return file_paths

def read_all_documents(file_paths: List[str]) -> List[LangchainDocument]:
    """Reads all specified documents and returns a list of Langchain Documents."""
    documents = []
    for filepath in file_paths:
        content = ""
        if filepath.endswith('.pdf'):
            content = read_pdf(filepath)
        elif filepath.endswith('.docx'):
            content = read_docx(filepath)
        elif filepath.endswith(('.md', '.txt')):
            content = read_md_txt(filepath)
        elif filepath.endswith('.csv'):
            content = read_csv(filepath)
        elif filepath.endswith('.xlsx'):
            content = read_xlsx(filepath)
        
        if content:
            # Tạo LangchainDocument từ nội dung và metadata
            # Metadata có thể bao gồm đường dẫn gốc của file để theo dõi
            documents.append(LangchainDocument(page_content=content, metadata={"source": filepath}))
    return documents

# --- 2. Hàm phân tích chính với LLM ---

def analyze_and_classify_labs(
    base_dirs: List[str], 
    laas_proposal_path: str, 
    llm: ChatGoogleGenerativeAI # Đã đổi kiểu từ Ollama sang ChatGoogleGenerativeAI
) -> Dict[str, Any]:
    """
    Main function to read documents, analyze LaaS proposal, and perform classifications.
    """
    results = {}

    print("Bước 1: Đọc tất cả các tệp tài liệu...")
    all_file_paths = get_file_paths(base_dirs)
    all_documents_langchain = read_all_documents(all_file_paths)
    
    # Chia nhỏ tất cả các tài liệu thành các chunks
    all_chunks = []
    for doc in all_documents_langchain:
        chunks = text_splitter.split_documents([doc])
        all_chunks.extend(chunks)
    
    # Tổng hợp nội dung từ tất cả các chunks (có thể rất lớn)
    # Cần cẩn trọng với giới hạn context window của LLM.
    # Với mục đích demo, ta sẽ lấy một phần hoặc toàn bộ chunks nếu LLM cho phép.
    # Đối với các yêu cầu tổng hợp (2, 3, 4), ta sẽ gửi các chunks liên quan tới LLM.
    
    # Tìm nội dung của tệp LaaS Proposal
    laas_proposal_content = ""
    for doc in all_documents_langchain:
        # Sử dụng os.path.normpath để chuẩn hóa đường dẫn trước khi so sánh
        if os.path.normpath(doc.metadata.get("source")) == os.path.normpath(laas_proposal_path):
            laas_proposal_content = doc.page_content
            break
    
    if not laas_proposal_content:
        print(f"Lỗi: Không tìm thấy tệp LaaS Proposal tại '{laas_proposal_path}'. Vui lòng kiểm tra đường dẫn và chắc chắn file có nội dung.")
        return {"error": "LAAS proposal not found."}

    print("Bước 2: Phân tích chi tiết Đề tài LaaS (Yêu cầu 1)...")
    prompt_req1 = PromptTemplate.from_template(f"""
    Bạn là một chuyên gia tư vấn công nghệ thông tin và giáo dục, có kiến thức sâu rộng về thị trường, xu hướng công nghệ mới, và đào tạo doanh nghiệp.
    Dựa trên tư duy dữ liệu và thông tin từ Đề xuất LaaS sau đây, hãy phân tích chi tiết và đầy đủ.

    Đề xuất LaaS:
    ---
    {laas_proposal_content[:30000]} # Giới hạn kích thước để tránh tràn context
    ---

    Hãy thực hiện các đánh giá mở rộng, giả thuyết, giả sử là đề xuất này có thể thực hiện được và đáp ứng được xu thế của thị trường đào tạo và công nghệ mới áp dụng trong Doanh nghiệp hiện nay.

    Xác định các vấn đề còn thiếu trong đề xuất, cần điều chỉnh thêm về:
    -   **Đào tạo**: Những nội dung đào tạo nào cần bổ sung hoặc điều chỉnh để phù hợp với nhu cầu thực tế và xu hướng công nghệ?
    -   **PoC/Demo trong thực tế Doanh nghiệp**: Làm thế nào để các Labs có thể phục vụ tốt hơn cho PoC (Proof of Concept) và Demo sản phẩm/giải pháp trong môi trường doanh nghiệp? Các kịch bản PoC nào cần ưu tiên?
    -   **Chú trọng kỹ thuật, đầu tư**: Nên tập trung vào hệ thống Labs nào? Các công nghệ và nền tảng kỹ thuật nào cần được ưu tiên đầu tư để đảm bảo tính hiện đại, linh hoạt và khả năng mở rộng (ví dụ: Containerization, Orchestration, Cloud-native, AI/MLOps)?
    -   **Bổ sung môn thí điểm**: Ngoài các môn đã nêu làm thí điểm, còn những môn gì (hoặc nhóm công nghệ) cần bổ sung để thu hút thị trường và nâng cao năng lực cạnh tranh?
    -   **Yêu cầu chung của hệ thống Labs thực tế**: Một hệ thống Labs thực tế cần đáp ứng những yêu cầu chung nào để phục vụ đa dạng các nhu cầu (đào tạo, PoC, phát triển)?

    Phản hồi bằng tiếng Việt, sử dụng định dạng Markdown với các tiêu đề rõ ràng cho từng phần phân tích.
    """)
    
    try:
        # Đối với ChatGoogleGenerativeAI, invoke() sẽ hoạt động tương tự như Ollama
        req1_analysis = llm.invoke(prompt_req1.format(laas_proposal_content=laas_proposal_content[:30000])).content # Lấy thuộc tính .content
        results['req1_laas_analysis'] = req1_analysis
    except Exception as e:
        results['req1_laas_analysis'] = f"Lỗi khi thực hiện phân tích Yêu cầu 1: {e}"
        print(f"Lỗi khi thực hiện phân tích Yêu cầu 1: {e}")

    print("Bước 3: Phân loại Labs cho Đào tạo và Giáo dục (Yêu cầu 2)...")
    
    file_metadata_summary = ""
    for doc in all_documents_langchain:
        file_metadata_summary += f"- File: {doc.metadata.get('source')} (Length: {len(doc.page_content)} chars)\n"
        if len(doc.page_content) > 1000: 
            file_metadata_summary += f"  Snippet: {doc.page_content[:500]}...\n"
        else:
            file_metadata_summary += f"  Content: {doc.page_content}\n"
        file_metadata_summary += "---\n"
    
    prompt_req2 = PromptTemplate.from_template(f"""
    Dựa trên khung nội dung từ đề xuất LaaS đã phân tích và các thông tin từ các tài liệu khác đã đọc (tên file và một phần nội dung được liệt kê dưới đây), hãy phân loại chi tiết các nhóm Labs thực hành cho Đào tạo và Giáo dục.
    Chú ý đến các xu hướng và yêu cầu hiện tại của thị trường.

    **Tổng quan về các tài liệu đã đọc:**
    {file_metadata_summary[:25000]} # Giới hạn kích thước

    **Đề xuất LaaS đã phân tích (tóm tắt các điểm chính liên quan đến đào tạo):**
    {laas_proposal_content[:5000]}

    **Các phân loại cần thực hiện:**
    -   **Phân loại các Nhóm Bộ môn**: Ví dụ: An toàn thông tin, Phân tích dữ liệu, Phát triển phần mềm, Hạ tầng Cloud, AI/ML, DevOps...
    -   **Phân loại các đối tượng học viên, vị trí vai trò nghiệp vụ, đối tượng Doanh nghiệp (nếu có)**: Ví dụ: Sinh viên CNTT, Kỹ sư bảo mật, Data Scientist, Quản trị hệ thống, Lãnh đạo doanh nghiệp, SMEs, Doanh nghiệp lớn...
    -   **Phân loại Khóa học từ các phân tích trong các Thư mục đã nêu**: Liệt kê các khóa học cụ thể hoặc loại khóa học có thể xây dựng dựa trên nội dung các tài liệu (ví dụ: Khóa học Pentest nâng cao, Khóa học Kỹ sư AI/ML trên AWS/Azure, Khóa học Phân tích dữ liệu với Power BI & MS-SQL).
    -   **Phân loại các Nhóm yêu cầu về hạ tầng thiết bị**: Ví dụ: máy chủ (VMware vSphere, Hyper-V, KVM), GPU (cho AI/ML), máy trạm Workstation Client, Pi4/Pi5 (cho IoT), AI Private Local, Data Analytics Platform, BigData (Hadoop, Spark), SharePoint, Exchange, CEH, Data Scientist, K8s node, MS-SQL HA, vSphere ICM8, vRealize Automation 8x, vRealize Operation Suite 8x, VCF 5.x, VCF 9x, POD container, K3S IoT MQTT, Python Jupyterhub, DevSecOps CI/CD Pipeline Data, Git, LPi, Security+, CyberSecurity+, CyberAsk+...

    Lưu ý: Các hệ thống Labs đều làm thực hành Online qua Web HTML5 hoặc nhúng tích hợp với LMS (Moodle 3/4x) có thêm OTP/MFA tăng cường bảo mật users session/device.

    Phản hồi bằng tiếng Việt, sử dụng định dạng Markdown với các tiêu đề rõ ràng và bullet points cho từng phân loại.
    """)
    
    try:
        req2_classification = llm.invoke(prompt_req2).content
        results['req2_education_labs_classification'] = req2_classification
    except Exception as e:
        results['req2_education_labs_classification'] = f"Lỗi khi thực hiện phân loại Yêu cầu 2: {e}"
        print(f"Lỗi khi thực hiện phân loại Yêu cầu 2: {e}")

    print("Bước 4: Phân tích Bài toán Dự án Doanh nghiệp và dịch vụ thuê Labs (Yêu cầu 3)...")
    prompt_req3 = PromptTemplate.from_template(f"""
    Dựa trên nội dung từ tất cả các tài liệu đã đọc (được tóm tắt về metadata và nội dung một phần) và sự hiểu biết về thị trường doanh nghiệp, hãy phân tích và đề xuất các bài toán dự án doanh nghiệp và dịch vụ thuê Labs theo yêu cầu cá nhân.

    **Tổng quan về các tài liệu đã đọc:**
    {file_metadata_summary[:25000]} # Giới hạn kích thước

    **Các phân loại và nội dung cần thực hiện:**
    -   **Phân loại Nhóm Doanh nghiệp**: Ví dụ: Ngân hàng, Viễn thông, Sản xuất, Chăm sóc sức khỏe, Chính phủ, Startup công nghệ, SMBs...
    -   **Phân loại lĩnh vực hoạt động Doanh nghiệp, nghiệp vụ của Doanh nghiệp (nếu có)**: Ví dụ: FinTech, HealthTech, E-commerce, Supply Chain, R&D, IT Operations, Compliance & Audit...
    -   **Phân loại Các Chương trình đào tạo, tập huấn phù hợp với từng loại Doanh nghiệp (nếu có)**: Ví dụ: Đào tạo về An toàn thông tin cho khối Ngân hàng, Nâng cao năng lực DevSecOps cho Startup, Triển khai Data Lake cho Doanh nghiệp sản xuất...
    -   **Phân loại các công nghệ và môi trường phù hợp với các nhóm Doanh nghiệp**: Ví dụ: AWS, Azure, GCP, VMware, Kubernetes, OpenStack, Power Platform, SAP, Oracle, SQL Server, Python, Java, .NET...
    -   **Mục tiêu phổ biến**: Liệt kê các mục tiêu chính mà doanh nghiệp hoặc cá nhân thường mong muốn khi thuê/sử dụng Labs (ví dụ: hỗ trợ đào tạo nội bộ Doanh nghiệp, nâng cao năng lực đội ngũ CNTT, tiết kiệm thời gian và tận dụng tối đa tài nguyên nội bộ sẵn có, thử nghiệm công nghệ mới, phát triển sản phẩm...).
    -   **Viết các kịch bản, thử nghiệm, các bài thực hành labs theo nghiệp vụ của từng nhóm Doanh nghiệp**: Đưa ra ít nhất 3-5 ví dụ cụ thể cho các kịch bản labs.
    -   **Tóm tắt các PoC, Showcase, hoặc Case study có trong các nhóm Sách Mastering, Cookbook hoặc các tài liệu hướng dẫn cài đặt, triển khai**: Tổng hợp các ví dụ thực tế về triển khai và ứng dụng.

    Lưu ý: Các hệ thống Labs đều làm thực hành Online qua Web HTML5 hoặc nhúng tích hợp với LMS (Moodle 3/4x làm online elearning) có thêm OTP/MFA tăng cường bảo mật users session/device.

    Phản hồi bằng tiếng Việt, sử dụng định dạng Markdown với các tiêu đề rõ ràng và bullet points cho từng phân loại/mục.
    """)
    
    try:
        req3_enterprise_labs_analysis = llm.invoke(prompt_req3).content
        results['req3_enterprise_labs_analysis'] = req3_enterprise_labs_analysis
    except Exception as e:
        results['req3_enterprise_labs_analysis'] = f"Lỗi khi thực hiện phân tích Yêu cầu 3: {e}"
        print(f"Lỗi khi thực hiện phân tích Yêu cầu 3: {e}")

    print("Bước 5: Lập bảng Dashboard Insight và So sánh mô hình Labs (Yêu cầu 4)...")
    prompt_req4 = PromptTemplate.from_template(f"""
    Tổng hợp tất cả các phân tích từ các yêu cầu trước (đặc biệt là yêu cầu 2 và 3) và thông tin từ các tài liệu đã đọc, hãy lập ra một bảng Dashboard insight và phần so sánh chi tiết.

    **Tổng quan về các tài liệu đã đọc và các phân tích trước:**
    {file_metadata_summary[:25000]} # Giới hạn kích thước
    {results.get('req2_education_labs_classification', 'Chưa có phân loại giáo dục.')[:5000]}
    {results.get('req3_enterprise_labs_analysis', 'Chưa có phân tích doanh nghiệp.')[:5000]}

    **Các phần cần có trong Dashboard Insight:**
    1.  **Dashboard Insight:**
        *   **Danh sách các môn:** Liệt kê các môn học chính (ví dụ: An toàn thông tin, Điện toán đám mây, AI/ML, Khoa học dữ liệu, DevOps...).
        *   **Danh sách Khóa học:** Liệt kê các khóa học cụ thể có thể cung cấp.
        *   **Danh sách các Labs:** Liệt kê các mô hình Labs hoặc chủ đề Labs (ví dụ: Lab Pentest Web, Lab K8s Cluster, Lab Data Pipeline, Lab vSphere 8...).
        *   **Cấu hình về Phần cứng, phần mềm đáp ứng tối thiểu:** Nêu rõ các yêu cầu về CPU, RAM, GPU, Storage, OS, Hypervisor, phần mềm ứng dụng cần thiết cho các Labs tiêu biểu.
        *   **Mô hình Labs thực hành:** Mô tả các mô hình Labs phổ biến (ví dụ: Labs cô lập VM, Labs containerized, Labs tích hợp Cloud native...).

    2.  **So sánh các yêu cầu, tính năng, chức năng, các khả năng và các yêu cầu kỹ thuật của từng mô hình Labs:**
        *   So sánh giữa các loại Labs đã nêu (ví dụ: Labs ảo hóa truyền thống, Labs dựa trên Container/Kubernetes, Labs tập trung vào Data/AI, Labs tích hợp môi trường doanh nghiệp).
        *   Điểm mạnh, điểm yếu của từng mô hình.
        *   Các tính năng và chức năng nổi bật.
        *   Các yêu cầu kỹ thuật đặc thù.
        *   Khả năng mở rộng, bảo mật, dễ quản lý.

    3.  **Yếu tố chung để quyết định xây dựng đầu tư hệ thống Labs On-premise Local/Co-location từ hạ tầng ảo hóa đến các Containers, VM, Dockers, API, Database cho Labs đào tạo-giáo dục online và cho PoC/Demo theo yêu cầu của nhóm Doanh nghiệp:**
        *   Các tiêu chí quyết định đầu tư (chi phí, hiệu quả, tính linh hoạt, bảo mật, khả năng tích hợp, xu hướng công nghệ).
        *   Xác định các thành phần cốt lõi cần ưu tiên đầu tư.
        *   Gợi ý về kiến trúc tổng thể.

    Phản hồi bằng tiếng Việt, sử dụng định dạng Markdown, trình bày dưới dạng bảng hoặc danh sách có cấu trúc rõ ràng cho phần Dashboard và so sánh.
    """)
    
    try:
        req4_dashboard_insight = llm.invoke(prompt_req4).content
        results['req4_dashboard_insight'] = req4_dashboard_insight
    except Exception as e:
        results['req4_dashboard_insight'] = f"Lỗi khi thực hiện phân tích Yêu cầu 4: {e}"
        print(f"Lỗi khi thực hiện phân tích Yêu cầu 4: {e}")

    return results

# --- 3. Thực thi hàm chính trong Jupyter Notebook ---

if __name__ == "__main__":
    print("Bắt đầu quá trình phân tích và phân loại...")
    analysis_results = analyze_and_classify_labs(
        base_dirs=BASE_DIRS,
        laas_proposal_path=LAAS_PROPOSAL_PATH,
        llm=llm
    )

    print("\n--- KẾT QUẢ PHÂN TÍCH VÀ PHÂN LOẠI ---")

    print("\n--- YÊU CẦU 1: PHÂN TÍCH ĐỀ XUẤT LAAS ---")
    print(analysis_results.get('req1_laas_analysis', "Không có kết quả cho Yêu cầu 1."))

    print("\n\n--- YÊU CẦU 2: PHÂN LOẠI LABS CHO ĐÀO TẠO VÀ GIÁO DỤC ---")
    print(analysis_results.get('req2_education_labs_classification', "Không có kết quả cho Yêu cầu 2."))

    print("\n\n--- YÊU CẦU 3: BÀI TOÁN DỰ ÁN DOANH NGHIỆP VÀ DỊCH VỤ THUÊ LABS ---")
    print(analysis_results.get('req3_enterprise_labs_analysis', "Không có kết quả cho Yêu cầu 3."))

    print("\n\n--- YÊU CẦU 4: BẢNG DASHBOARD INSIGHT VÀ SO SÁNH ---")
    print(analysis_results.get('req4_dashboard_insight', "Không có kết quả cho Yêu cầu 4."))

    print("\nQuá trình phân tích hoàn tất.")
```

