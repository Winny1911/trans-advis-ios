//
//  ManageBidDetailViewModel.swift
//  TA
//
//  Created by Applify  on 05/01/22.
//

import Foundation
class ManageBidDetailViewModel: NSObject {
    func getManageBidsDetailApi(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorBidDetailsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getManageBidsDetailApiV2(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModelV2?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModelV2>.makeApiCall(APIUrl.UserApis.contractorBidDetailsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func confirmRecallBidApi(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorRecallBid, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func viewBidLogApi(_ params :[String:Any],_ result:@escaping(GetBidLogResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<GetBidLogResponseModel>.makeApiCall(APIUrl.UserApis.contractorBidLog, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func deleteBidFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.deleteBidFile, params: params, headers: headers, method: .delete) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAgreementGeneratetApi(_ params :[String:Any],_ result:@escaping(GetAgreementGenerateResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<GetAgreementGenerateResponseModel>.makeApiCall(APIUrl.UserApis.agreementGenerate, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func downloadPDF(_ params :[String:Any]){

        guard let baseURL = URL(string: APIUrl.UserApis.downloadPDFBid) else {
            print("URL invalid")
            return
        }
        
        print("URL valid")
        
        // Crie uma URLRequest com a URL recebida
            var request = URLRequest(url: baseURL)
            
            // Defina o método HTTP para POST
            request.httpMethod = "POST"
            
            // Defina o cabeçalho Content-Type para application/json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Converta o dicionário em formato JSON e coloque-o no corpo da requisição
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
            
            // Crie uma sessão de URL
            let session = URLSession.shared
            
            // Crie uma tarefa de data para fazer a requisição
            let task = session.dataTask(with: request) { data, response, error in
                // Verifique se ocorreu algum erro na requisição
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Erro desconhecido")
                    return
                }
                
                // Verifique se a resposta HTTP tem código 200 (OK)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("Código de resposta HTTP inválido: \(httpResponse.statusCode)")
                    return
                }
                
                // Salve o arquivo PDF no diretório de documentos do usuário
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent("arquivo.pdf")
                try? data.write(to: fileURL)
                
                // Imprima a mensagem de sucesso
                //Progress.instance.hide()
                print("Arquivo salvo em \(fileURL.absoluteString)")
            }
            
            // Inicie a tarefa de data
            task.resume()

    }
    
}
