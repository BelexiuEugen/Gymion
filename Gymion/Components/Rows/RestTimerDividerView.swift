import UIKit

class RestTimerDividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 1. The Line
        let lineView = UIView()
        lineView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3) // Light blue
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        // 2. The Label
        let timeLabel = UILabel()
        timeLabel.text = "2:00"
        timeLabel.textColor = .systemBlue
        timeLabel.font = .boldSystemFont(ofSize: 14)
        timeLabel.textAlignment = .center
        
        // THE TRICK: Give it a solid background to cover the line
        timeLabel.backgroundColor = .systemBackground
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        
        // 3. Constraints
        NSLayoutConstraint.activate([
            // Set container height
            self.heightAnchor.constraint(equalToConstant: 27),
            
            // Pin line to edges and center vertically
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1.5), // Thickness of the line
            
            // Center the label
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // Give the label some breathing room so the line doesn't touch the text
            timeLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
