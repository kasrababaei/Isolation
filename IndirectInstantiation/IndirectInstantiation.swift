import Synchronization

@Sendable
func bind<T>(
    _ type: T.Type,
    lifetime: Lifetime<T> = .unique,
    to instantiator: @escaping () ->  T
) -> @Sendable () ->  T {
    Instantiator.bind(type, lifetime: lifetime, to: instantiator)
}

enum Instantiator {
    private typealias TypeInstantiator = () -> Any

    private static let instantiators: Mutex<[TypeIdentifier: TypeInstantiator]> = .init([:])
}

private extension Instantiator {
    @Sendable
    static func bind<T>(
        _ type: T.Type,
        lifetime: Lifetime<T> = .unique,
        to instantiator: @escaping () -> T
    ) -> @Sendable () ->  T {
        instantiators.withLock { dictionary in
            let key = TypeIdentifier(type)

            guard dictionary[key] == nil else {
                return
            }
            var temp: [TypeIdentifier: TypeInstantiator] = [key: { lifetime.instance(instantiator) }]
            temp.merge(dictionary, uniquingKeysWith: { $1 })
            dictionary = temp
        }

        return instance
    }

    @Sendable
    private static func instance<T>() ->  T {
        if let mockInstance: T = mockInstance() {
            return mockInstance
        }

        let instantiator = instantiators.withLock { $0[TypeIdentifier(T.self)] }
        return instantiator!() as! T
    }
}

// MARK: - Mocking
func mock<T>(_ type: T.Type, to instantiator: @escaping () -> T) {
    Instantiator.mock(type, to: instantiator)
}

extension Instantiator {
    private static let mockInstantiators: Atomic<[TypeIdentifier: TypeInstantiator]> = .init([:])

    fileprivate static func mock<T>(_ type: T.Type, to instantiator: @escaping () -> T) {
        mockInstantiators.withLock { $0[TypeIdentifier(type)] = instantiator }
    }

    static func unmock() {
        mockInstantiators.withLock { $0 = [:] }
    }

    private static func mockInstance<T>() -> T? {
        guard case let .enabled(required) = mocking.withLock({ $0 })
        else { return nil }

        guard let instantiator = mockInstantiators.withLock({ $0[TypeIdentifier(T.self)] }),
              let instance = instantiator() as? T
        else {
            if required {
                assertionFailure("Missing mock for \(T.self)")
            }
            return nil
        }

        return instance
    }
}

extension Instantiator {
    enum Mocking: Sendable {
        case disabled
        case enabled(required: Bool)
    }

    static let mocking: Atomic<Mocking> = .init(.disabled)
}

struct TypeIdentifier: Hashable, Sendable {
    let name: String
    let identifier: ObjectIdentifier

    init(_ type: Any.Type) {
        self.name = "\(type)"
        self.identifier = ObjectIdentifier(type)
    }
}
