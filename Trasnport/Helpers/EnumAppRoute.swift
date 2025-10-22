enum EnumAppRoute: Hashable {
    case cityPicker(fromField: Bool)
    case stationPicker(city: String, fromField: Bool)
    case tickets
    case filters
    case carrierInfo(TicketModel)
}
