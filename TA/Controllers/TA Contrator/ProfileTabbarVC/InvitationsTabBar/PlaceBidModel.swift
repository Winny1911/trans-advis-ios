//
//  PlaceBidModel.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import Foundation
class PlaceBidModel {
    var date: String = ""
    var homeOwnerFirst: String = ""
    var homeOwnerSecond: String = ""
    var streetAddress: String = ""
    var mailingAddress: String = ""
    var cellPhone: String = ""
    var email: String = ""
    var hoa: String = ""
    var permit: Bool = false
    var insurance: String = ""
    var claimNumber: String = ""
    var insFullyApproved: Bool = false
    var insPartialApproved: Bool = false
    var retail: Bool = false
    var retailWDepreciation: Bool = false
    var mainDwellingRoof: String = ""
    var shedSQ: String = ""
    var decking: String = ""
    var flatRoofSQ: String = ""
    var total: String = ""
    var totalSQ: String = ""
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
    var cutInstallRidgeVent: Bool = false
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
    var satelliteDish: Bool = false
    var antenna: Bool = false
    var detachOnly: String = ""
    var detachDispose: String = ""
    var materialLocation: String = ""
    var dumpsterLocation: String = ""
    var specialInstructions: String = ""
    var notes: String = ""
    var roofing: String = ""
    var roofingPrice: String = ""
    var debrisRemoval: String = ""
    var debrisRemovalPrice: String = ""
    var overheadProfit: String = ""
    var codeUpgrades: String = ""
    var paymentTermsDeductible: Bool = false
    var paymentTermsFinance: Bool = false
    var homeOwner: String = ""
    var homeOwnerDate: String = ""
    var homeOwnerDateBA: String = ""
    var aegcRepresentative: String = ""
    var aegcRepresentativeBA: String = ""
    var dateHomeOwner1: String = ""
    var dateHomeOwner2: String = ""
    var dateAEGC: String = ""
    var detachedGarageSQ: String = ""
    
    init() {
    }
    
    init(date: String,
         homeOwnerFirst: String,
         homeOwnerSecond: String,
         streetAddress: String,
         mailingAddress: String,
         cellPhone: String,
         email: String,
         hoa: String,
         permit: Bool,
         insurance: String,
         claimNumber: String,
         insFullyApproved: Bool,
         insPartialApproved: Bool,
         retail: Bool,
         retailWDepreciation: Bool,
         mainDwellingRoof: String,
         shedSQ: String,
         decking: String,
         flatRoofSQ: String,
         total: String,
         totalSQ: String,
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
         cutInstallRidgeVent: Bool,
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
         satelliteDish: Bool,
         antenna: Bool,
         detachOnly: String ,
         detachDispose: String,
         materialLocation: String,
         dumpsterLocation: String ,
         specialInstructions: String,
         notes: String,
         roofing: String,
         roofingPrice: String,
         debrisRemoval: String,
         debrisRemovalPrice: String,
         overheadProfit: String,
         codeUpgrades: String ,
         paymentTermsDeductible: Bool,
         paymantTermsFinance: Bool,
         homeOwner: String,
         homeOwnerDate: String,
         homeOwnerDateBA: String,
         aegcRepresentative: String,
         aegcRepresentativeBA: String,
         dateHomeOwner1: String,
         dateHomeOwner2: String,
         dateAEGC: String,
         detachedGarageSQ: String) {
        self.date = date
        self.homeOwnerFirst = homeOwnerFirst
        self.homeOwnerSecond = homeOwnerSecond
        self.streetAddress = streetAddress
        self.mailingAddress = mailingAddress
        self.cellPhone = cellPhone
        self.email = email
        self.hoa = hoa
        self.permit = permit
        self.insurance = insurance
        self.claimNumber = claimNumber
        self.insFullyApproved = insFullyApproved
        self.insPartialApproved = insPartialApproved
        self.retail = retail
        self.retailWDepreciation = retailWDepreciation
        self.mainDwellingRoof = mainDwellingRoof
        self.shedSQ = shedSQ
        self.decking = decking
        self.flatRoofSQ = flatRoofSQ
        self.total = total
        self.totalSQ = totalSQ
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
        self.debrisRemovalPrice = debrisRemovalPrice
        self.overheadProfit = overheadProfit
        self.codeUpgrades = codeUpgrades
        self.paymentTermsDeductible = paymentTermsDeductible
        self.paymentTermsFinance = paymantTermsFinance
        self.homeOwner = homeOwner
        self.homeOwnerDate = homeOwnerDate
        self.homeOwnerDateBA = homeOwnerDateBA
        self.aegcRepresentative = aegcRepresentative
        self.aegcRepresentativeBA = aegcRepresentativeBA
        self.dateHomeOwner1 = dateHomeOwner1
        self.dateHomeOwner2 = dateHomeOwner2
        self.dateAEGC = dateAEGC
        self.detachedGarageSQ = detachedGarageSQ
    }
}
