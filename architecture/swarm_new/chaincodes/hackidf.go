package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)
var (
	fileName = "hackidf"
)

//structure of chaincode
type HackidfChaincode struct{
}

// User Structure
type User struct{
	Username string `json:"Username"`
	Email string `json:"Email"`
}

// Organisation Structure
type Organisation struct{
	OrgName string `json:"OrgName"`
	IsVerified string `json:"IsVerified"`
}

// Claim 
type Claim struct{
	UserID string `json:"UserID"`
	OrgID string `json:"OrgID"`
	Skill string `json:"Skill"`
	Comments string `json:"Comments"`
	Timestamp string `json:"Timestamp"`
	IsVerified string `json:"IsVerified"`
}

//initialization function
func (t *HackidfChaincode) Init(stub shim.ChaincodeStubInterface)pb.Response{
	// Whatever variable initialisation you want can be done here //
	return shim.Success(nil)
}

// invoking functions
func  (t *HackidfChaincode) Invoke(stub shim.ChaincodeStubInterface)pb.Response{
	// IF-ELSE-IF all the functions 
	function, args := stub.GetFunctionAndParameters()
	if function == "CreateUser" {
		return t.CreateUser(stub, args)
	}else if function == "CreateOrg" {
		return t.CreateOrg(stub, args)
	}else if function == "VerifyOrg" {
		return t.VerifyOrg(stub, args)
	}else if function == "MakeClaim" {
		return t.MakeClaim(stub, args)
	}else if function == "VerifyClaim"{
		return t.VerifyClaim(stub, args)
	}else if function == "Query"{
		return t.Query(stub, args)
	}
	fmt.Println("invoke did not find func : " + function) //error
	return shim.Error("Received unknown function invocation")
	// end of all functions
}

// Adding info about a user
func  (t *HackidfChaincode) CreateUser(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	var UserID = args[0]
	var Username = args[1]
	var Email = args[2]
	// checking for an error or if the user already exists
	UserAsBytes, err := stub.GetState(Username)
	if err != nil {
		return shim.Error("Failed to get Username:" + err.Error())
	}else if UserAsBytes != nil{
		return shim.Error("User with current username already exists")
	}
	var User = &User{Username:Username, Email:Email}
	UserJsonAsBytes, err :=json.Marshal(User)
	if err != nil {
		shim.Error("Error encountered while Marshalling")
	}
	err = stub.PutState(UserID, UserJsonAsBytes)
	if err != nil {
		shim.Error("Error encountered while Creating User")
	}
	fmt.Println("Ledger Updated Successfully")
	return shim.Success(nil)
}

// Adding info about an Organisations
func  (t *HackidfChaincode) CreateOrg(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	var OrgID = args[0]
	var OrgName = args[1]
	var IsVerified = "No"
	// checking for an error or if the user already exists
	OrgAsBytes, err := stub.GetState(OrgID)
	if err != nil {
		return shim.Error("Failed to get Organisation:" + err.Error())
	}else if OrgAsBytes != nil{
		return shim.Error("Organisation is already registered")
	}
	var Organisation = &Organisation{OrgName:OrgName, IsVerified:IsVerified}
	OrgJsonAsBytes, err :=json.Marshal(Organisation)
	if err != nil {
		shim.Error("Error encountered while Marshalling")
	}
	err = stub.PutState(OrgID, OrgJsonAsBytes)
	if err != nil {
		shim.Error("Error encountered while Creating Organisation")
	}
	fmt.Println("Ledger Updated Successfully")
	return shim.Success(nil)
}

// Verify Organisation
func  (t *HackidfChaincode) VerifyOrg(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	var OrgID = args[0]
	OrgAsBytes, err := stub.GetState(OrgID)
	if err != nil {
		return shim.Error("Failed to get Organisation:" + err.Error())
	}else if OrgAsBytes == nil{
		return shim.Error("Organisation not registered")
	}
	var Organisation Organisation
	err = json.Unmarshal(OrgAsBytes, &Organisation)
	if err != nil {
		return shim.Error("Error encountered during unmarshalling the data")
	}
	Organisation.IsVerified = "True"
	OrgJsonAsBytes, err :=json.Marshal(Organisation)
	if err != nil {
		return shim.Error("Error encountered while remarshalling")
	}
	err = stub.PutState(OrgID, OrgJsonAsBytes)
	if err != nil {
		return shim.Error("error encountered while putting state")
	}
	fmt.Println("VERIFIED!!")
	return shim.Success(nil)
}

// Make Claim
func  (t *HackidfChaincode) MakeClaim(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	var Hash = args[0]
	var UserID = args[1]
	var OrgID = args[2]
	var Skill = args[3]
	var Timestamp = args[4]
	var IsVerified = "False"
	var Claim = &Claim{UserID:UserID, OrgID:OrgID, Skill:Skill, Comments:"NIL", Timestamp:Timestamp ,IsVerified:IsVerified}
	ClaimJsonAsBytes, err :=json.Marshal(Claim)
	if err != nil {
		shim.Error("Error encountered while Marshalling")
	}
	err = stub.PutState(Hash, ClaimJsonAsBytes)
	if err != nil {
		shim.Error("Error encountered while Making Claim")
	}
	fmt.Println("Ledger Updated Successfully")
	return shim.Success(nil)
}

// Verify Claim
func  (t *HackidfChaincode) VerifyClaim(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	var Hash = args[0]
	ClaimAsBytes, err := stub.GetState(Hash)
	if err != nil {
		return shim.Error("Failed to get Claim:" + err.Error())
	}else if ClaimAsBytes == nil{
		return shim.Error("Claim not made")
	}
	var Claim Claim
	err = json.Unmarshal(ClaimAsBytes, &Claim)
	if err != nil {
		return shim.Error("Error encountered during unmarshalling the data")
	}
	Claim.IsVerified = "True"
	ClaimJsonAsBytes, err :=json.Marshal(Claim)
	if err != nil {
		return shim.Error("Error encountered while remarshalling")
	}
	err = stub.PutState(Hash, ClaimJsonAsBytes)
	if err != nil {
		return shim.Error("error encountered while putting state")
	}
	fmt.Println("VERIFIED!!")
	return shim.Success(nil)
}

// Query Function
func  (t *HackidfChaincode) Query(stub shim.ChaincodeStubInterface, args []string)pb.Response{
	DataAsBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Error encountered")
	}else if DataAsBytes == nil {
		return shim.Error("No Data")
	}
	return shim.Success(DataAsBytes)
}
// MAIN FUNCTION
func  main() {
	err := shim.Start(new(HackidfChaincode))
	if err != nil {
		fmt.Printf("Error starting Chaincode: %s", err)
	}
}