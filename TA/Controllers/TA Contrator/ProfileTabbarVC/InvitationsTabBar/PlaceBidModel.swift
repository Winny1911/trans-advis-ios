//
//  PlaceBidModel.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import Foundation
class PlaceBidModel {
    
    //    var bidAmount: String = ""
    //    var amountReceivable: String = ""
    //    var startDate: String = ""
    //    var endDate: String = ""
    //    var description: String = ""
    //    var arrOfFilesCount :Int = 0
    var homeOwnerFirst: String = ""
    var homeOwnerSecond: String = ""
    var streetAddress: String = ""
    var mailingAddress: String = ""
    var cellPhone: String = ""
    var email: String = ""
    var hoa: String = ""
    var permit: String = ""
    var insurance: String = ""
    var claimNeumber: String = ""
    var insFullyApproved: String = ""
    var insPartialApproved: String = ""
    var retail: String = ""
    var retailWDepreciation: String = ""
    var mainDwellingRoof: String = ""
    var shedSQ: String = ""
    var decking: String = ""
    var flatRoofSQ: String = ""
    var total: String = ""
    var deducible: String = ""
    var fe: String = ""
    var retailB: String = ""
    var be: String = ""
    var brand: String = ""
    var style: String = ""
    var color: String = ""
    var white: String = ""
    var brown: String = ""
    var aegc: String = ""
    var iko: String = ""
    var oc: String = ""
    var ocB: String = ""
    var gaf: String = ""
    var airVent: String = ""
    var cutInstallRidgeVent: String = ""
    var black: String = ""
    var brownB: String = ""
    var whiteB: String = ""
    var copper: String = ""
    var blackB: String = ""
    var brownC: String = ""
    var grey: String = ""
    var whiteC: String = ""
    var removeReplace: String = ""
    var deatchReset: String = ""
    var removeCoverHoles: String = ""
    var permaBoot: String = ""
    var permaBootB: String = ""
    var pipeJack: String = ""
    var pipeJackB: String = ""
    var removeReplaceB: String = ""
    var deatchResetB: String = ""
    var colorB: String = ""
    var satelliteDish: String = ""
    var antenna: String = ""
    var detachOnly: String = ""
    var detachDispose: String = ""
    var materialLocation: String = ""
    var dumpsterLocation: String = ""
    var specialInstructions: String = ""
    var notes: String = ""
    var roofing: String = ""
    var roofingPrice: String = ""
    var debrisRemoval: String = ""
    var overheadProfit: String = ""
    var codeUpgrades: String = ""
    var paymentTermsDeductible: String = ""
    var paymentTermsFinance: String = ""
    var homeOwner: String = ""
    var homeOwnerDate: String = ""
    var homeOwnerBA: String = ""
    var homeOwnerDateBA: String = ""
    var aegcRepresentative: String = ""
    var aegcRepresentativeBA: String = ""
    
    init() {
    }
    
    init(homeOwnerFirst: String,
         homeOwnerSecond: String,
         streetAddress: String,
         mailingAddress: String,
         cellPhone: String,
         email: String,
         hoa: String,
         permit: String,
         insurance: String,
         claimNeumber: String,
         insFullyApproved: String,
         insPartialApproved: String,
         retail: String,
         retailWDepreciation: String,
         mainDwellingRoof: String,
         shedSQ: String,
         decking: String,
         flatRoofSQ: String,
         total: String,
         deducible: String,
         fe: String,
         retailB: String,
         be: String,
         brand: String,
         style: String,
         color: String,
         white: String,
         brown: String,
         aegc: String,
         iko: String,
         oc: String,
         ocB: String,
         gaf: String,
         airVent: String,
         cutInstallRidgeVent: String,
         black: String,
         brownB: String,
         whiteB: String,
         copper: String,
         blackB: String,
         brownC: String,
         grey: String,
         whiteC: String,
         removeReplace: String,
         deatchReset: String,
         removeCoverHoles: String,
         permaBoot: String,
         permaBootB: String,
         pipeJack: String,
         pipeJackB: String,
         removeReplaceB: String,
         deatchResetB: String,
         colorB: String,
         satelliteDish: String,
         antenna: String,
         detachOnly: String ,
         detachDispose: String,
         materialLocation: String,
         dumpsterLocation: String ,
         specialInstructions: String,
         notes: String,
         roofing: String,
         roofingPrice: String,
         debrisRemoval: String,
         overheadProfit: String,
         codeUpgrades: String ,
         paymentTermsDeductible: String,
         paymantTermsFinance: String,
         homeOwner: String,
         homeOwnerDate: String,
         homeOwnerBA: String ,
         homeOwnerDateBA: String,
         aegcRepresentative: String,
         aegcRepresentativeBA: String) {
        self.homeOwnerFirst = homeOwnerFirst
        self.homeOwnerSecond = homeOwnerSecond
        self.streetAddress = streetAddress
        self.mailingAddress = mailingAddress
        self.cellPhone = cellPhone
        self.email = email
        self.hoa = hoa
        self.permit = permit
        self.insurance = insurance
        self.claimNeumber = claimNeumber
        self.insFullyApproved = insFullyApproved
        self.insPartialApproved = insPartialApproved
        self.retail = retail
        self.retailWDepreciation = retailWDepreciation
        self.mainDwellingRoof = mainDwellingRoof
        self.shedSQ = shedSQ
        self.decking = decking
        self.flatRoofSQ = flatRoofSQ
        self.total = total
        self.deducible = deducible
        self.fe = fe
        self.retailB = retailB
        self.be = be
        self.brand = brand
        self.style = style
        self.color = color
        self.white = white
        self.brown = brown
        self.aegc = aegc
        self.iko = iko
        self.oc = oc
        self.ocB = ocB
        self.gaf = gaf
        self.airVent = airVent
        self.cutInstallRidgeVent = cutInstallRidgeVent
        self.black = black
        self.brownB = brownB
        self.whiteB = whiteB
        self.copper = copper
        self.blackB = blackB
        self.brownC = brownC
        self.grey = grey
        self.whiteC = whiteC
        self.removeReplace = removeReplace
        self.deatchReset = deatchReset
        self.removeCoverHoles = removeCoverHoles
        self.permaBoot = permaBoot
        self.permaBootB = permaBootB
        self.pipeJack = pipeJack
        self.pipeJackB = pipeJackB
        self.removeReplaceB = removeReplaceB
        self.deatchResetB = deatchResetB
        self.colorB = colorB
        self.satelliteDish = satelliteDish
        self.antenna = antenna
        self.detachOnly = detachOnly
        self.detachDispose = detachDispose
        self.materialLocation = materialLocation
        self.dumpsterLocation = dumpsterLocation
        self.specialInstructions = specialInstructions
        self.notes = notes
        self.roofing = roofing
        self.roofingPrice = roofingPrice
        self.debrisRemoval = debrisRemoval
        self.overheadProfit = overheadProfit
        self.codeUpgrades = codeUpgrades
        self.paymentTermsDeductible = paymentTermsDeductible
        self.paymentTermsFinance = paymantTermsFinance
        self.homeOwner = homeOwner
        self.homeOwnerDate = homeOwnerDate
        self.homeOwnerBA = homeOwnerBA
        self.homeOwnerDateBA = homeOwnerDateBA
        self.aegcRepresentative = aegcRepresentative
        self.aegcRepresentativeBA = aegcRepresentativeBA
    }
}
