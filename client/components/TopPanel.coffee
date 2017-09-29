React = require('react')
FontAwesome = require('react-fontawesome')
import { connect } from 'react-redux'

import { LinkContainer } from 'react-router-bootstrap'

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Modal from 'react-bootstrap/lib/Modal'

import { Link } from 'react-router-dom'

import * as actions from '../redux/actions'

import UserName, {color} from './UserName'
import CfStatus from './CfStatus'

import needUnknownWarning from '../lib/needUnknownWarning'

import styles from './TopPanel.css'

class TopPanel extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            showWarning: (not @props.unknownWarningShown) and needUnknownWarning(@props.myUser)
        @closeWarning = @closeWarning.bind(this)
        @openWarning = @openWarning.bind(this)

    closeWarning: ->
        @props.setUnknownWarningShown()
        @setState
            showWarning: false

    openWarning: ->
        @setState
            showWarning: true

    componentDidUpdate: (prevProps, prevState) ->
        newState =
            showWarning: (not @props.unknownWarningShown) and needUnknownWarning(@props.myUser)
        if newState.showWarning != prevState.showWarning
            @setState(newState)

    render: ->
        <div>
            <Navbar fixedTop fluid>
                <Navbar.Form pullLeft>
                    <Button onClick={@props.toggleTree}>{"\u200B"}<FontAwesome name="bars"/></Button>
                </Navbar.Form>
                <Navbar.Header>
                    <Navbar.Brand>
                        {
                        if @props.myUser?.name
                            <span>
                                <UserName user={@props.myUser}/>
                                <span className={styles.separator}/>
                                <span title="Уровень">{@props.myUser.level.current}</span>
                                <span className={styles.separator}/>
                                <span title="Рейтинг" style={color: color(@props.myUser)}>{@props.myUser.rating}</span>
                                {" / "}
                                <span title="Активность">{@props.myUser.activity.toFixed(1)}</span>
                                <span className={styles.separator}/>
                                <CfStatus cf={@props.myUser.cf} />
                                {needUnknownWarning(@props.myUser) &&
                                    <span title="Учетная запись не активирована, напишите мне" className="text-danger" onClick={@openWarning}><FontAwesome name="exclamation-triangle"/></span>}
                            </span>
                        else
                            "Неизвестный пользователь"
                        }
                    </Navbar.Brand>
                </Navbar.Header>
                <Navbar.Form pullRight>
                    {
                    if @props.me?._id
                        <ButtonGroup>
                            {
                            ###
                            <LinkContainer to="/profile" isActive={() -> false}>
                                <Button bsStyle="primary">
                                    <FontAwesome name="cog"/> Профиль
                                </Button>
                            </LinkContainer>
                            ###
                            }
                            <Button bsStyle="success" onClick={@props.handleLogout}>
                                <FontAwesome name="sign-out"/> Выход
                            </Button>
                        </ButtonGroup>
                    else
                        <ButtonGroup>
                            <LinkContainer to="/register" isActive={() -> false}>
                                <Button bsStyle="primary">
                                    <FontAwesome name="user-plus"/> Регистрация
                                </Button>
                            </LinkContainer>
                            <LinkContainer to="/login" isActive={() -> false}>
                                <Button bsStyle="success">
                                    <FontAwesome name="sign-in"/> Вход
                                </Button>
                            </LinkContainer>
                        </ButtonGroup>
                    }
                </Navbar.Form>
            </Navbar>
            {
            @state.showWarning &&
            <div className="static-modal">
                <Modal.Dialog>
                    <Modal.Header>
                        <Modal.Title>Учетная запись не активирована</Modal.Title>
                    </Modal.Header>

                    <Modal.Body>
                        <div>
                            <p>Ваша учетная запись еще не активирована. Вы можете сдавать задачи, но напишите мне,
                            чтобы я активировал вашу учетную запись. Мои контакты — на страничке
                            {" "}<Link to="/material/0">О курсе</Link>.</p>
                        </div>
                    </Modal.Body>

                    <Modal.Footer>
                        <Button bsStyle="primary" onClick={@closeWarning}>OK</Button>
                    </Modal.Footer>

                </Modal.Dialog>
            </div>
            }
        </div>

mapStateToProps = (state) ->
    return
        unknownWarningShown: state.unknownWarningShown

mapDispatchToProps = (dispatch, ownProps) ->
    return
        setUnknownWarningShown: () -> dispatch(actions.setUnknownWarningShown())

export default connect(mapStateToProps, mapDispatchToProps)(TopPanel)