import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet var roomTypeDetailLabel: UILabel!
    
    //MARK: - CHARGES OUTLETS
    @IBOutlet var chargesNumberOfNightLabel: UILabel!
    @IBOutlet var chargesNumberOfNightsDetailLabel: UILabel!
    
    @IBOutlet var chargesRoomTypeLabel: UILabel!
    @IBOutlet var chargesRoomTypeDetailLabel: UILabel!
    
    @IBOutlet var chargesWiFiLabel: UILabel!
    @IBOutlet var chargesWiFiDetailLabel: UILabel!
    
    @IBOutlet var chargesTotalLabel: UILabel!
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatepickerCellIndexPath = IndexPath(row: 1, section: 1)
    
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var registrations: Registration?
    var roomType: RoomType?
    
    init?(coder: NSCoder, registrations: Registration?) {
        self.registrations = registrations
        super .init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isCheckInDatePikerVisible: Bool = false {
        didSet{
            checkInDatePicker.isHidden = !isCheckInDatePikerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        updateDateView()
        updateNumberOfGuests()
        updateRoomType()
        updateChargesSection()
        updateRegistrationViews()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatepickerCellIndexPath where isCheckInDatePikerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatepickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            isCheckInDatePikerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePikerVisible == false {
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath  {
            isCheckInDatePikerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK: - Update Methods
    func updateRegistrationViews() {
        var wifiTotal2 = 0
        
        guard let registrations = registrations else { return }
        title = "Редактирование Регистрации"
        
        firstNameTextField.text = registrations.firstName
        lastNameTextField.text = registrations.lastName
        emailTextField.text = registrations.emailAdress
        
        checkInDateLabel.text = "\(registrations.checkInDate.formatted(date: .abbreviated, time: .omitted))"
        checkOutDateLabel.text = "\(registrations.checkOutDate.formatted(date: .abbreviated, time: .omitted))"
        
        wifiSwitch.isOn = registrations.wifi
        
        numberOfAdultsLabel.text = "\(registrations.numberOfAdults)"
        numberOfChildrenLabel.text = "\(registrations.numberOfChildren)"
        
        roomTypeDetailLabel.text = "\(registrations.roomType.name)"
        
        chargesNumberOfNightsDetailLabel.text = "\(registrations.checkInDate.formatted(date: .numeric, time: .omitted))-\(registrations.checkOutDate.formatted(date: .numeric, time: .omitted))"
        
        let dateComponents = Calendar.current.dateComponents([.day], from: registrations.checkInDate, to: registrations.checkOutDate)
        let numberOfNights = dateComponents.day ?? 0
        chargesNumberOfNightLabel.text = "\(numberOfNights)"
        
        chargesRoomTypeLabel.text = "$\(registrations.roomType.price * numberOfNights)"
        chargesRoomTypeDetailLabel.text = "\(registrations.roomType.name)@\(registrations.roomType.price)"
        
        if wifiSwitch.isOn {
            wifiTotal2 = 10 * numberOfNights
            chargesWiFiLabel.text = "$\(wifiTotal2)"
        }
        chargesTotalLabel.text = "$\(registrations.roomType.price * numberOfNights + wifiTotal2)"
        chargesWiFiDetailLabel.text = "\(wifiSwitch.isOn ? "Да" : "Нет")"
    }
    
    func updateSaveButton() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        saveButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }
    
    func updateDateView() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date )
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
   
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeDetailLabel.text = roomType.name
        } else {
            roomTypeDetailLabel.text = "Не Выбранно"
        }
        updateChargesSection()
    }
    
    //MARK: - updateChargesSection
    func updateChargesSection() {
        let dateComponents = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        let numberOfNights = dateComponents.day ?? 0
        
        chargesNumberOfNightLabel.text = "\(numberOfNights)"
        chargesNumberOfNightsDetailLabel.text = "\(checkInDatePicker.date.formatted(date: .numeric, time: .omitted))-\(checkOutDatePicker.date.formatted(date: .numeric, time: .omitted))"
        
        let roomTotalPrice: Int
        if let roomType = roomType {
            roomTotalPrice = roomType.price * numberOfNights
            chargesRoomTypeLabel.text = "$ \(roomTotalPrice)"
            chargesRoomTypeDetailLabel.text = "\(roomType.name) @ $\(roomType.price)"
        } else {
            roomTotalPrice = 0
            chargesRoomTypeLabel.text = "__"
            chargesRoomTypeDetailLabel.text = "__"
        }
        
        let wifiTotal: Int
        if wifiSwitch.isOn {
            wifiTotal = 10 * numberOfNights
        } else {
            wifiTotal = 0
        }
        chargesWiFiLabel.text = "$\(wifiTotal)"
        chargesWiFiDetailLabel.text = "\(wifiSwitch.isOn ? "Да" : "Нет")"
        chargesTotalLabel.text = "$\(roomTotalPrice + wifiTotal)"
    }
    
    //MARK: - selectRoomTypeTableViewController
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    // MARK: - @IBACTIONS
    @IBAction func firstName(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func lastName(_ sender: UITextField) {
        updateSaveButton()
    }
    @IBAction func email(_ sender: UITextField) {
        updateSaveButton()
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
        updateChargesSection()
    }
    
    @IBAction func adultsLabelChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        updateChargesSection()
    }
    
    @IBAction func wifiChanged(_ sender: UISwitch) {
        updateChargesSection()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder, sender: Any?) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController =  SelectRoomTypeTableViewController(coder: coder)
        
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateChargesSection()
    }
    //MARK: - Prepare Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind", let roomType = roomType else { return }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOut = checkOutDatePicker.date
        let adults = Int(numberOfAdultsLabel.text ?? "") ?? 0
        let children = Int(numberOfChildrenLabel.text ?? "") ?? 0
        let wifi = wifiSwitch.isOn
        
        registrations = Registration(firstName: firstName, lastName: lastName, emailAdress: email, checkInDate: checkInDate, checkOutDate: checkOut, numberOfAdults: adults, numberOfChildren: children, wifi: wifi, roomType: roomType)
    }
}

